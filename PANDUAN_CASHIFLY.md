# 👑 Cashifly - Panduan Aplikasi Keuangan Yang Mulia

Aplikasi mobile pencatatan dan analisis keuangan cerdas dengan tema modern segar **Ungu ke Biru Dongkeran (Navy & Vibrant Purple)**, dirancang khusus dengan fitur alokasi pos dana dan pemantauan multi-rekening/dompet digital.

---

## 🌟 Fitur-Fitur yang Sudah Terimplementasi

1. **Autentikasi & Identitas Akun Google**:
   - Tampilan masuk modern dengan tombol resmi Google Sign-In.
   - Pilihan masuk instan sebagai **Yang Mulia 👑** untuk pengujian cepat.
   - Opsi input nama & email Google kustom secara fleksibel.
   - Siap disambungkan ke Google OAuth di Supabase Auth.

2. **Dashboard Bottom Navigation (2 Menu Utama)**:
   - **Home (Beranda & Analisis)**: Pusat kendali keuangan dan grafik.
   - **Profile (Profil Akun)**: Identitas pengguna, ringkasan statistik, dan tombol keluar.
   - Dilengkapi **Floating Action Button (+)** di tengah untuk mencatat transaksi kapan saja.

3. **Pencatatan Transaksi Harian Fleksibel**:
   - Memilih jenis: **Pengeluaran** atau **Pendapatan**.
   - Input nominal Rupiah dengan chip cepat (+50rb, +100rb, +250rb, +500rb, +1jt).
   - **Pemisahan Pos Dana**:
     - 🔥 **Dana Panas**: Keperluan aktif sehari-hari *(dijadikan opsi normal/default)*.
     - 🛡️ **Dana Darurat**: Dana cadangan proteksi.
     - 💎 **Ditabung**: Investasi & tabungan masa depan.
   - **Pemisahan Tipe Penyimpanan**:
     - 🏦 **Bank**: Pilihan bank populer (BCA, Mandiri, BRI, BNI, BSI, Bank Jago, CIMB Niaga, Permata, dll.) atau input nama bank kustom.
     - 📱 **E-Wallet**: Pilihan e-wallet (GoPay, OVO, DANA, ShopeePay, LinkAja, AstraPay, dll.).
     - 💵 **Cash**: Uang tunai / dompet fisik.

4. **Fitur Analisis Finansial Lengkap di Home**:
   - 💳 **Kartu Total Aset Keseluruhan**: Gradien ungu-navy dengan tombol sembunyikan saldo dan ringkasan Pemasukan vs Pengeluaran.
   - 📊 **Pemisahan Pos Dana**: Grafik rasio batang warna-warni dan kartu rincian saldo serta persentase Dana Panas, Dana Darurat, dan Tabungan.
   - 🏦 **Pemisahan Akun Penyimpanan**: Tab interaktif untuk melihat total saldo di Bank, E-Wallet, dan Cash, lengkap dengan rincian per rekening/aplikasi.
   - 📈 **Analisis Arus Kas Mingguan**: Grafik batang interaktif membandingkan Pendapatan (hijau segar) dan Pengeluaran (ungu cerah) untuk Minggu 1 s.d. Minggu 4.
   - 📜 **Daftar Transaksi Terkini**: Filter transaksi (Semua, Keluar, Masuk) dengan badge pos dana & sumber pembayaran, serta fitur hapus.

5. **Desain & Tema Segar**:
   - Palet warna: **Deep Navy (`#090D1A`, `#11182C`)** dipadukan dengan **Royal Purple (`#7C3AED`, `#8B5CF6`)** dan aksen **Neon Cyan (`#06B6D4`)** serta **Mint Green (`#10B981`)**.

6. **Halaman Profil & Tombol Keluar**:
   - Kartu profil Google dengan avatar Yang Mulia 👑.
   - Statistik total saldo, jumlah transaksi, dan status database.
   - Tombol **Keluar dari Akun** dengan popup dialog konfirmasi.

---

## 🗄️ Langkah Menghubungkan ke Supabase (Nanti saat Yang Mulia Siap)

Sesuai permintaan Yang Mulia, konfigurasi database dapat dihubungkan belakangan dengan sangat mudah:

### Langkah 1: Eksekusi Skrip Database
1. Buka [Supabase Dashboard](https://supabase.com/dashboard).
2. Buat proyek baru (misal: `cashifly-db`).
3. Masuk ke menu **SQL Editor**, buka file `supabase_schema.sql` yang sudah kami sediakan di folder proyek, lalu salin dan klik **Run**.
4. Tabel `transactions` dan kebijakan keamanannya (Row Level Security) akan otomatis terbuat.

### Langkah 2: Isi URL & Anon Key
Buka file [`lib/services/supabase_service.dart`](file:///home/ibe-gallagher/Documents/Kuliah/Semester%205/Pemrograman%20Aplikasi%20Mobile/project_cashifly/cashifly/lib/services/supabase_service.dart) dan masukkan:
```dart
static const String supabaseUrl = 'https://PROJECT_ID_YANG_MULIA.supabase.co';
static const String supabaseAnonKey = 'ANON_KEY_YANG_MULIA';
```

### Langkah 3: Aktifkan Dependensi Supabase di `pubspec.yaml`
Cukup hilangkan tanda komentar (`#`) pada:
```yaml
supabase_flutter: ^2.8.0
google_sign_in: ^6.2.2
```
lalu jalankan `flutter pub get`.

---

## 🚀 Cara Menjalankan Aplikasi

Jalankan perintah berikut di terminal:
```bash
flutter run
```
Aplikasi langsung dapat dijalankan di emulator Android, iOS, maupun Chrome/Linux desktop.

