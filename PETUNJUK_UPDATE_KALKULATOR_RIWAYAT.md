# CekBMIku — Update Kalkulator & Riwayat BMI

Paket ini melanjutkan project CekBMIku (Login + Daftar + Beranda + Rekomendasi + Artikel + Notifikasi) dan mengubah **dua layar** sesuai desain UI yang diberikan.

## Yang diubah

| Berkas | Perubahan |
|---|---|
| `lib/screens/bmi_calculator_screen.dart` | Form Pria/Wanita, tinggi, berat, tombol hitung, hasil inline, ringkasan kategori, referensi BMI, saran dan artikel |
| `lib/screens/bmi_history_screen.dart` | **Baru:** grafik tren BMI/berat, filter 3/6/12 bulan/semua, riwayat dan urutan terbaru/terlama |
| `lib/screens/shell_screen.dart` | Header Riwayat BMI, lonceng hanya pada Beranda; navbar bawah tetap di luar scroll |
| `lib/router/app_router.dart` | Route `/history` menuju halaman baru; `/calculator` tidak berubah |
| `lib/blocs/bmi/bmi_bloc.dart` | Validasi tinggi 50–250 cm, berat 10–300 kg agar sama dengan petunjuk di layar |

## Cara pemasangan (paket update)

1. Buat commit Git cadangan atau salin folder project terlebih dahulu.
2. Ekstrak ZIP update.
3. Salin folder `lib/` dari ZIP **ke folder project yang berisi `pubspec.yaml`**. Pilih Merge folder dan Replace **hanya berkas dengan nama sama**, bukan Delete folder `lib` lama.
4. `bmi_history_screen.dart` adalah file baru di `lib/screens/`. Jangan ditempatkan di `lib/blocs/`.
5. Di terminal Android Studio jalankan:

   ```bash
   flutter pub get
   flutter analyze
   flutter run
   ```

6. Stop lalu Run ulang (bukan sekadar Hot Reload) jika ada perubahan navigasi/router.

## Cara uji

1. Login akun pengguna biasa → buka tab **Kalkulator**.
2. Isi misalnya tinggi **170**, berat **70**, pilih gender, tekan **Hitung BMI**. BMI yang dihitung adalah 70 / 1.7² = **24,2** (pembulatan satu desimal). Hasil, referensi dan rekomendasi terlihat **di halaman Kalkulator**, tanpa berpindah otomatis.
3. Buka tab **Riwayat** → pemeriksaan tercatat. Pilih periode dan tampilan nilai BMI/berat. Tekan kartu untuk membuka detail hasil pemeriksaan.
4. Untuk muncul garis grafik, buat setidaknya dua pemeriksaan dalam **bulan yang berbeda**; bila hanya satu bulan, akan tampil satu titik. Data contoh Januari–Juni pada desain **tidak ditambahkan secara palsu** ke riwayat pengguna.
5. Gulir layar: bottom navbar tetap berada di bawah karena dimiliki `ShellScreen`.

## Batasan

- Riwayat disimpan lokal melalui `SharedPreferences`, tidak disinkronkan ke cloud.
- BMI referensi dewasa adalah indikator penyaringan, bukan diagnosis medis; ketepatan kategori perlu disesuaikan dengan kelompok usia/populasi bila dipakai secara klinis.
- Struktur file dan import diuji secara statis; **build Flutter dan emulator belum diuji** di lingkungan pembuatan ZIP.
- Mode fullscreen sebelumnya tetap dipertahankan di `main.dart` tanpa perubahan.
