# FinSight AI 📈🤖
### Privacy-First, On-Device AI Financial Intelligence Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend%20%26%20Sync-3ECF8E?logo=supabase)](https://supabase.com)
[![Groq](https://img.shields.io/badge/Groq-LPU%20Inference-F05A28)](https://groq.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**FinSight AI** is a smart, privacy-centric personal finance manager for Android that parses transactional SMS messages entirely on-device, categorizes cash flows, tracks account balances and credit cards, detects recurring subscriptions, and provides intelligent AI-driven financial insights with hybrid on-device / cloud LLM execution.

---

## 🌟 Key Highlights

- **🔒 100% Privacy-First & Offline Capable**: All SMS reading, parsing, regex matching, and financial ledger calculations run locally on your device via SQLite/Drift. Your financial records never leave your phone unless you explicitly opt in to cloud sync.
- **⚡ Hybrid AI Financial Coach**:
  - Primary: Ultra-fast LLM tool-calling powered by **Groq** (`openai/gpt-oss-120b`).
  - Fallback: Deterministic on-device rule evaluation and local context generation when offline or rate-limited.
- **📨 Automated Bank SMS Intelligence**: Robust parsing for 15+ major Indian, UAE, and international banks (SBI, HDFC, ICICI, Axis, PNB, Canara, DBS, Kotak, etc.) with UPI reference deduplication.
- **🔄 Optional Cloud Sync (Supabase)**: Multi-device ledger synchronization, encrypted cloud backup/restore, and community classification rules protected by Row Level Security (RLS).
- **📊 Modern Interactive Visualizations**: Real-time spending breakdowns, categorical pie charts, budget utilization tracking, and merchant trends.
- **🔁 Subscription & Recurring Mandate Radar**: Automatically flags recurring charges (Netflix, Spotify, utility bills) and predicts future billing cycles.
- **🛡️ Custom Classification & Rule Engine**: Create customizable conditions and actions to auto-categorize, rename, or block transactions.

---

## 📱 Architecture & Tech Stack

```
                          ┌─────────────────────────────┐
                          │   FinSight Flutter Mobile   │
                          └──────────────┬──────────────┘
                                         │
                 ┌───────────────────────┴───────────────────────┐
                 ▼                                               ▼
    ┌───────────────────────────┐                   ┌───────────────────────────┐
    │     On-Device Engine      │                   │     Cloud Integration     │
    ├───────────────────────────┤                   ├───────────────────────────┤
    │ • Kotlin SMS NativeBridge │                   │ • Supabase Auth           │
    │ • Drift (SQLite) Storage  │                   │ • Supabase Database (RLS) │
    │ • Local Bank Parsers      │                   │ • Encrypted Cloud Backups │
    │ • Rule Engine & Dedup     │                   │ • Groq AI Tool Calling    │
    └───────────────────────────┘                   └───────────────────────────┘
```

- **Framework**: [Flutter](https://flutter.dev) (Dart 3.x)
- **State Management**: [Riverpod 2.x](https://riverpod.dev)
- **Navigation & Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Local Database**: [Drift](https://drift.simonbinder.eu/) (SQLite with reactive DAOs)
- **Backend as a Service**: [Supabase Flutter](https://supabase.com) (Auth, PostgREST, Storage)
- **AI / LLM Engine**: [Groq Cloud API](https://groq.com) + Local rule-based classifier fallback
- **Data Serialization**: [Freezed](https://pub.dev/packages/freezed) & `json_serializable`

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.2.0`)
- [Android Studio](https://developer.android.com/studio) / Android SDK (API 26+)
- Physical Android phone or Emulator (SMS reading requires Android environment)
- Accounts: [Supabase](https://supabase.com) & [Groq](https://console.groq.com)

### 1. Clone the Repository

```bash
git clone https://github.com/KritishBokde91/FinSight_Revised.git
cd FinSight_Revised/finsight_ai
```

### 2. Environment Configuration

Copy `.env.example` to create your local `.env`:

```bash
cp .env.example .env
```

Open `.env` and configure your credentials:

```ini
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOi...
SUPABASE_PUBLISHABLE_KEY=sb_publishable_...

# AI Inference (Groq)
GROQ_API_KEY=gsk_...
GROQ_MODEL=openai/gpt-oss-120b

# Fallback AI (Optional)
GEMINI_API_KEY=AIzaSy...
```

> ⚠️ **Security Warning**: Never commit your `.env` file to version control. The `.gitignore` file is strictly configured to protect `.env`.

### 3. Setup Supabase Database Schema

1. Open your Supabase Dashboard: `https://supabase.com/dashboard/project/<your-project-id>/sql`
2. Open the SQL Editor and paste the contents of [`lib/core/supabase/supabase_schema.sql`](lib/core/supabase/supabase_schema.sql).
3. Click **Run** to provision the tables (`transactions`, `budgets`, `goals`, `user_profiles`, `cloud_backups`, `community_rules`) with strict Row Level Security (RLS) policies.

### 4. Install Dependencies & Build Runners

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the Application

Connect an Android device with USB debugging enabled:

```bash
flutter run
```

---

## 🧪 Testing & Verification

Run the comprehensive unit and integration test suite:

```bash
flutter test
```

Analyze the codebase for static analysis compliance:

```bash
flutter analyze
```

---

## 📂 Project Structure

```
finsight_ai/
├── android/                         # Native Android Kotlin platform channel bridge
├── lib/
│   ├── core/                        # Core system components
│   │   ├── database/                # Drift SQLite database schema & DAOs
│   │   ├── di/                      # Dependency injection providers (Riverpod)
│   │   ├── repositories/            # Central LLM & balance repositories
│   │   ├── routing/                 # GoRouter app navigation configuration
│   │   ├── services/                # Preferences & permission services
│   │   ├── supabase/                # Supabase client, schema & sync services
│   │   └── theme/                   # FinSight design system & theme tokens
│   ├── features/                    # Feature-driven domain modules
│   │   ├── ai_assistant/            # AI Financial Coach & Groq LLM integration
│   │   ├── analytics/               # Visual charts, spending breakdowns & trends
│   │   ├── auth/                    # Cloud sign-in, sign-up & offline session
│   │   ├── backup/                  # JSON export & encrypted cloud backup
│   │   ├── billing/                 # Simulated / Play Store in-app subscriptions
│   │   ├── budget_planner/          # Budget categorization & limits
│   │   ├── dashboard/               # Main home dashboard screen
│   │   ├── financial_goals/         # Savings goals & progress tracking
│   │   ├── onboarding/              # Welcome introduction carousel & entry points
│   │   ├── permissions/             # SMS and Notification permission flow
│   │   ├── profile/                 # Profile & app settings screen
│   │   ├── rules/                   # Custom transaction rules engine
│   │   ├── sms_intelligence/        # Bank parsers & SMS native sync engine
│   │   ├── subscriptions/           # Recurring subscription detection & radar
│   │   └── transactions/            # Ledger views & transaction details
│   └── main.dart                    # Application entry point
├── test/                            # Unit & repository mock test suites
├── .env.example                     # Environment template file
├── .gitignore                       # Production-grade Git ignore specifications
├── Documentation.MD                 # In-depth architectural & API documentation
└── README.md                        # Project overview & quickstart guide
```

---

## 📄 Documentation

For full architectural deep-dives, database design, SMS parsing protocols, and cloud sync lifecycle, see **[`Documentation.MD`](Documentation.MD)**.

---

## 🤝 Contributing & License

Contributions, issues, and feature requests are welcome!

Distributed under the **MIT License**. See `LICENSE` for more information.
