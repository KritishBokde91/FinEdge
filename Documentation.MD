# FinSight AI — Technical Documentation & Architecture Reference 📚

This document details the architecture, data lifecycles, parsing algorithms, cloud synchronization protocols, and AI integration mechanisms of **FinSight AI**.

---

## Table of Contents
1. [Architectural Overview](#1-architectural-overview)
2. [Data Layer & Persistence](#2-data-layer--persistence)
   - [Local Storage (Drift / SQLite)](#local-storage-drift--sqlite)
   - [Cloud Database (Supabase PostgreSQL)](#cloud-database-supabase-postgresql)
3. [SMS Intelligence Pipeline](#3-sms-intelligence-pipeline)
   - [Native Bridge Communication](#native-bridge-communication)
   - [Bank Parser Engine](#bank-parser-engine)
   - [Deduplication & Collision Avoidance](#deduplication--collision-avoidance)
4. [AI Financial Coach Engine](#4-ai-financial-coach-engine)
   - [Groq Tool Calling Execution](#groq-tool-calling-execution)
   - [Offline Context Fallback](#offline-context-fallback)
5. [Cloud Synchronization & Auth Lifecycle](#5-cloud-synchronization--auth-lifecycle)
   - [Authentication Modes](#authentication-modes)
   - [Incremental Sync Protocol](#incremental-sync-protocol)
   - [Historical Batch Sync Protocol](#historical-batch-sync-protocol)
   - [Row-Level Security (RLS)](#row-level-security-rls)
6. [Classification Rules Engine](#6-classification-rules-engine)
7. [Subscription Detection Radar](#7-subscription-detection-radar)
8. [Configuration & Environment Reference](#8-configuration--environment-reference)

---

## 1. Architectural Overview

FinSight AI employs a **Local-First, Cloud-Additive** architectural paradigm.

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Flutter UI Presentation Layer                   │
│   (Dashboard, Transactions, AI Assistant, Analytics, Settings, Rules)  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                       Riverpod Dependency Injection
                                    │
        ┌───────────────────────────┴────────────────────────────┐
        ▼                                                        ▼
┌────────────────────────────────┐              ┌────────────────────────────────┐
│   On-Device Core Engine        │              │   Cloud Integration Layer      │
│ ────────────────────────────── │              │ ────────────────────────────── │
│ • MethodChannel ('sms')        │              │ • SupabaseClient (Auth & DB)   │
│ • BankParserFactory (Regex)    │              │ • SupabaseSyncService          │
│ • Drift AppDatabase (SQLite)   │              │ • Groq LPU API Client          │
│ • RuleEngine & Deduplication   │              │ • Supabase Storage (Backups)   │
└────────────────────────────────┘              └────────────────────────────────┘
```

### Core Principles
- **Privacy by Default**: Unauthenticated or offline users have 100% functionality on their physical device. SMS contents, ledger records, rules, and balances are stored only in on-device SQLite.
- **Additive Cloud**: Signing in to Supabase enables seamless data replication and cross-device availability without interrupting the local database operations.
- **Fail-Safe Processing**: Failures in network or third-party APIs (such as Groq or Supabase) degrade gracefully to local computations without crashing or blocking the user experience.

---

## 2. Data Layer & Persistence

### Local Storage (Drift / SQLite)
Local persistence is managed using **Drift** (schema version 6) over standard SQLite.

#### Key Tables:
- `SmsMetadataTable`: Records raw SMS metadata (`sender`, `body`, `timestamp`, `isProcessed`, `confidence`).
- `TransactionsTable`: The local ledger containing parsed transactions:
  - `id` (Text, Primary Key): Hash or unique synthetic ID.
  - `amount`, `merchant`, `category`, `timestamp`, `isIncome`, `accountSource`, `reference`, `currency`.
- `AccountBalancesTable`: Tracks inferred bank and credit card balances.
- `CardsTable`: Auto-discovered debit/credit cards linked by bank and last-4 digits.
- `BudgetsTable` & `GoalsTable`: Target limits, spending goals, and progress.
- `RulesTable` & `RuleApplicationsTable`: User-defined categorizations and their execution history.
- `SubscriptionsTable`: Identified recurring charges and predicted payment intervals.

### Cloud Database (Supabase PostgreSQL)
Supabase replicates user records for multi-device sync and automated backups.

```sql
-- Transactions table with user isolation and RLS
CREATE TABLE public.transactions (
  id             TEXT PRIMARY KEY,
  user_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount         NUMERIC(14,2) NOT NULL,
  merchant       TEXT NOT NULL,
  category       TEXT NOT NULL,
  is_income      BOOLEAN NOT NULL DEFAULT FALSE,
  account_source TEXT NOT NULL DEFAULT '',
  reference      TEXT,
  currency       TEXT NOT NULL DEFAULT 'INR',
  sms_id         TEXT,
  sms_hash       TEXT,
  date           TIMESTAMPTZ NOT NULL,
  synced_at      TIMESTAMPTZ DEFAULT NOW()
);
```

---

## 3. SMS Intelligence Pipeline

### Native Bridge Communication
1. **Background SMS Broadcast Receiver** (`SmsBroadcastReceiver.kt`):
   - Listens to `android.provider.Telephony.SMS_RECEIVED`.
   - Extracts sender address, timestamp, and message body.
   - Pushes new messages directly into local storage.
2. **Foreground Inbox Synchronization** (`MainActivity.kt` & `SmsSyncService.dart`):
   - Queries `content://sms/inbox` using `MethodChannel('com.genzloop.finsight_ai/sms')`.
   - Reads incremental batches using `since` timestamp parameters to minimize battery and memory overhead.

### Bank Parser Engine
The parser engine utilizes pattern-matching abstractions across international and Indian financial institutions:

| Bank / Provider | Parser Class | Capabilities |
|---|---|---|
| **SBI** | `SbiBankParser` | Debits, Credits, UPI references, ATM cash withdrawals |
| **HDFC** | `HdfcBankParser` | Credit Cards, NetBanking, Balance updates, IMPS/NEFT |
| **ICICI** | `IciciBankParser` | UPI VPA identification, multi-currency credit cards |
| **Axis Bank** | `AxisBankParser` | Account last-4 detection, merchant name extraction |
| **Kotak / PNB / Canara / DBS** | Specialized parsers | Standardized debit/credit alerts & balance inference |
| **Juspay / Payment Gateways** | `JuspayParser` | Payment gateway transaction confirmations |

### Deduplication & Collision Avoidance
To avoid duplicate entries from multiple SMS messages (e.g., promotional alerts, reversal notices, or duplicate network deliveries):
- **UPI Reference Checking**: Uses a 12-digit UPI reference number within a ±30-minute sliding time window.
- **Hash-based Primary Key**:
  `transactionId = parsed.transactionHash ?? generateTransactionId(sender, amount, timestamp)`
- **Idempotent Inserts**: Local inserts use `InsertMode.insertOrReplace`; Supabase sync uses `upsert(..., onConflict: 'id')`.

---

## 4. AI Financial Coach Engine

FinSight AI utilizes an intelligent dual-mode inference pipeline designed for real-time speed, accuracy, and reliability.

```
User Query ("How much did I spend on food this month?")
                     │
                     ▼
             [AiCoachEngine]
                     │
         Is Groq Available?
            ├── Yes ──► Send query + Data context to Groq API (openai/gpt-oss-120b)
            │           ├── Tool Calling: Category aggregation, merchant breakdown
            │           └── Formats markdown answer + chart metadata
            │
            └── No ───► Fallback: Deterministic local context evaluation
                        ├── Computes local spending summaries from Drift SQLite
                        └── Returns structured rule-based financial advice
```

### Groq Tool Calling Execution
- Model: `openai/gpt-oss-120b` (configurable via `GROQ_MODEL`).
- Base URL: `https://api.groq.com/openai/v1`.
- Provides financial contextual summaries: transactions over the last 30-90 days, active budgets, and savings goals.
- Directly returns structured JSON tags (`{"chart_type": "pie", "data": {...}}`) that the Flutter UI dynamically renders into interactive charts.

---

## 5. Cloud Synchronization & Auth Lifecycle

### Authentication Modes
1. **Offline Mode**:
   - The user chooses "Continue Offline" during onboarding or cloud login.
   - All operations operate normally on device.
2. **Cloud Authenticated**:
   - Authenticated via Supabase (`signUp()` / `signInWithPassword()`).
   - Enables real-time reactive user state via `currentSupabaseUserProvider`.

### Incremental Sync Protocol
Triggered automatically whenever a new SMS is successfully parsed:
```
SmsSyncService.syncInbox()
   └── txRepo.insertTransaction(localTx)
          └── supabaseSyncService.syncNewTransaction(localTx)
                 └── If user signed in: upsert to Supabase 'transactions' table
```

### Historical Batch Sync Protocol
Triggered once upon successful sign-in or sign-up in `CloudLoginPage`:
```
CloudLoginPage._handleEmailAuth()
   └── supabaseSyncService.syncAllLocalTransactions()
          ├── Reads all rows from Drift transactionsTable
          ├── Batches into chunks of 200 records
          └── Issues idempotent upsert calls to Supabase
```

### Row-Level Security (RLS)
Every cloud table is secured so that users cannot query or mutate records belonging to other users:
```sql
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "transactions: users manage own"
  ON public.transactions FOR ALL USING (auth.uid() = user_id);
```

---

## 6. Classification Rules Engine

The Rule Engine allows users to automate their financial organization:

- **Conditions**: Check fields like `merchant`, `amount`, `isIncome`, `smsBody`, or `accountSource` using operators like `contains`, `equals`, `greaterThan`, or `matchesRegex`.
- **Actions**:
  - `setCategory(newCategory)`
  - `renameMerchant(cleanName)`
  - `blockTransaction()`: Excludes non-financial or promotional SMS messages from the financial ledger.

---

## 7. Subscription Detection Radar

The subscription detector evaluates incoming transactions against historical records:
- Identifies identical merchant charges occurring at predictable intervals (weekly, monthly, quarterly, annual).
- Matches against known subscription providers (Netflix, Amazon Prime, Spotify, YouTube, iCloud, etc.).
- Calculates the `nextBillingDate` and surfaces upcoming renewal notices on the dashboard.

---

## 8. Configuration & Environment Reference

| Environment Variable | Required | Default / Example | Purpose |
|---|---|---|---|
| `SUPABASE_URL` | Yes (for cloud) | `https://xxxx.supabase.co` | Supabase project API URL |
| `SUPABASE_ANON_KEY` | Yes (for cloud) | `eyJhbGciOi...` | Supabase anonymous API key |
| `SUPABASE_PUBLISHABLE_KEY`| Optional | `sb_publishable_...` | Supabase publishable key |
| `GROQ_API_KEY` | Yes (for AI) | `gsk_...` | Groq high-speed LLM inference key |
| `GROQ_MODEL` | No | `openai/gpt-oss-120b` | Groq model identifier |
| `GEMINI_API_KEY` | Optional | `AIzaSy...` | Secondary fallback LLM key |

---

*For support, security disclosures, or questions, please open an issue in the official repository.*
