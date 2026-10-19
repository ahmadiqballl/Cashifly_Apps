-- ====================================================================
-- SKRIP DATABASE SUPABASE UNTUK CASHIFLY
-- Silakan salin & jalankan skrip ini di:
-- Supabase Dashboard -> Project Yang Mulia -> SQL Editor -> Run
-- ====================================================================

-- 1. Buat Tabel Transaksi
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

-- 2. Aktifkan Row Level Security (RLS) agar data aman per pengguna
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- 3. Kebijakan Keamanan (RLS Policies): User hanya bisa CRUD data miliknya
CREATE POLICY "Pengguna hanya melihat transaksi sendiri" 
ON public.transactions FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Pengguna hanya menambah transaksi sendiri" 
ON public.transactions FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Pengguna hanya mengubah transaksi sendiri" 
ON public.transactions FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Pengguna hanya menghapus transaksi sendiri" 
ON public.transactions FOR DELETE 
USING (auth.uid() = user_id);

-- 4. Indeks Performa untuk Pencarian Cepat Berdasarkan Pengguna & Tanggal
CREATE INDEX IF NOT EXISTS idx_transactions_user_date 
ON public.transactions (user_id, date DESC);

