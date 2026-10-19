class SupabaseConfig {
  /// URL proyek Supabase Yang Mulia
  static const String supabaseUrl = 'https://qkvihdfwoloxmnurlxly.supabase.co';

  /// Anon Key Supabase Yang Mulia
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrdmloZGZ3b2xveG1udXJseGx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE5OTc0MTMsImV4cCI6MjEwNzU3MzQxM30.Oi34pCkNQnQCenWIH_Q4IxYFbmcGPi2TgkVlyLSWtLA';

  /// Cek apakah Supabase sudah dikonfigurasi
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseUrl != 'https://YOUR_PROJECT_ID.supabase.co' &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY';

  /// Script SQL untuk membuat tabel di Supabase SQL Editor
  static const String databaseSchemaSql = '''
-- ========================================================
-- CASHIFLY DATABASE SCHEMA (SUPABASE POSTGRESQL)
-- ========================================================

-- 1. Buat Tabel Transactions
CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    amount NUMERIC(15, 2) NOT NULL DEFAULT 0,
    type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
    fund_category TEXT NOT NULL CHECK (fund_category IN ('danaPanas', 'danaDarurat', 'tabungan')),
    account_type TEXT NOT NULL CHECK (account_type IN ('bank', 'eWallet', 'cash')),
    account_name TEXT NOT NULL,
    category TEXT NOT NULL,
    date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Aktifkan Row Level Security (RLS)
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- 3. Kebijakan RLS (User hanya bisa membaca & mengelola data miliknya sendiri)
CREATE POLICY "Users can view their own transactions" 
ON public.transactions FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own transactions" 
ON public.transactions FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own transactions" 
ON public.transactions FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own transactions" 
ON public.transactions FOR DELETE 
USING (auth.uid() = user_id);

-- 4. Index untuk performa pencarian berdasarkan tanggal & user
CREATE INDEX IF NOT EXISTS idx_transactions_user_date 
ON public.transactions (user_id, date DESC);
''';
}
