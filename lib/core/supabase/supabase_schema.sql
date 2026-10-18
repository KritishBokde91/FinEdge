-- FinSight AI — Supabase Schema
-- Run this in your Supabase SQL Editor at:
-- https://supabase.com/dashboard/project/thhzlwyugcericqxndqu/sql

-- ─────────────────────────────────────────────────────────────────
-- 1. User profiles (extends auth.users)
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  display_name TEXT,
  avatar_url TEXT,
  currency TEXT DEFAULT 'INR',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_profiles: users manage own"
  ON public.user_profiles FOR ALL USING (auth.uid() = id);

-- ─────────────────────────────────────────────────────────────────
-- 2. Cloud backups metadata
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cloud_backups (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  storage_path TEXT NOT NULL,
  database_version INTEGER NOT NULL,
  transaction_count INTEGER DEFAULT 0,
  size_bytes BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.cloud_backups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cloud_backups: users manage own"
  ON public.cloud_backups FOR ALL USING (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────────
-- 3. Community classification rules
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.community_rules (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  contributed_by UUID REFERENCES auth.users(id),
  name TEXT NOT NULL,
  description TEXT,
  conditions JSONB NOT NULL,
  actions JSONB NOT NULL,
  upvotes INTEGER DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.community_rules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "community_rules: anyone reads" ON public.community_rules FOR SELECT USING (TRUE);
CREATE POLICY "community_rules: auth contributes"
  ON public.community_rules FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────────
-- 4. Community merchant → category mappings
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.community_merchants (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  merchant_name TEXT UNIQUE NOT NULL,
  category TEXT NOT NULL,
  subcategory TEXT,
  upvotes INTEGER DEFAULT 1,
  contributed_by UUID REFERENCES auth.users(id),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.community_merchants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "community_merchants: anyone reads" ON public.community_merchants FOR SELECT USING (TRUE);
CREATE POLICY "community_merchants: auth contributes"
  ON public.community_merchants FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "community_merchants: auth upserts"
  ON public.community_merchants FOR UPDATE USING (auth.role() = 'authenticated');

-- ─────────────────────────────────────────────────────────────────
-- 5. User transactions (synced from on-device SMS parsing)
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.transactions (
  id            TEXT PRIMARY KEY,               -- local transaction id (hash)
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount        NUMERIC(14,2) NOT NULL,
  merchant      TEXT NOT NULL,
  category      TEXT NOT NULL,
  is_income     BOOLEAN NOT NULL DEFAULT FALSE,
  account_source TEXT NOT NULL DEFAULT '',
  reference     TEXT,
  currency      TEXT NOT NULL DEFAULT 'INR',
  sms_id        TEXT,                            -- native SMS id (nullable)
  sms_hash      TEXT,                            -- dedup key = transaction id
  date          TIMESTAMPTZ NOT NULL,
  synced_at     TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "transactions: users manage own"
  ON public.transactions FOR ALL USING (auth.uid() = user_id);

-- Index for fast per-user queries
CREATE INDEX IF NOT EXISTS transactions_user_id_date_idx
  ON public.transactions (user_id, date DESC);

-- ─────────────────────────────────────────────────────────────────
-- 6. User budgets
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.budgets (
  id            TEXT PRIMARY KEY,
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  category      TEXT NOT NULL,
  limit_amount  NUMERIC(14,2) NOT NULL,
  start_date    TIMESTAMPTZ NOT NULL,
  end_date      TIMESTAMPTZ NOT NULL,
  synced_at     TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.budgets ENABLE ROW LEVEL SECURITY;
CREATE POLICY "budgets: users manage own"
  ON public.budgets FOR ALL USING (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────────
-- 7. User financial goals
-- ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.goals (
  id              TEXT PRIMARY KEY,
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  target_amount   NUMERIC(14,2) NOT NULL,
  current_amount  NUMERIC(14,2) NOT NULL DEFAULT 0,
  target_date     TIMESTAMPTZ NOT NULL,
  category        TEXT NOT NULL DEFAULT 'General',
  synced_at       TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "goals: users manage own"
  ON public.goals FOR ALL USING (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────────
-- 8. Storage bucket for encrypted backups
-- ─────────────────────────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public)
  VALUES ('backups', 'backups', FALSE)
  ON CONFLICT DO NOTHING;

CREATE POLICY "backups: user upload"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'backups' AND auth.uid()::text = (storage.foldername(name))[1]);
CREATE POLICY "backups: user download"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'backups' AND auth.uid()::text = (storage.foldername(name))[1]);
CREATE POLICY "backups: user delete"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'backups' AND auth.uid()::text = (storage.foldername(name))[1]);
