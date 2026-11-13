# CekBMIku — Login sebagai gerbang awal

Perubahan ini dibuat berdasarkan **CekBMIKu_Flutter_MateriKuliah-main(1).zip** yang dikirim, dengan tampilan dari **Masuk CekBMIku(1).png**.

## Yang berubah

- `lib/router/app_router.dart`: halaman awal menjadi `/login`; seluruh halaman aplikasi dijaga agar tamu tidak bisa masuk sebelum login; admin hanya bisa membuka `/admin`.
- `lib/screens/login_screen.dart`: desain putih-biru sesuai referensi, logo, email, password tampil/sembunyi, ingat saya, Masuk, Daftar.
- `assets/images/cekbmiku_logo_mark.png`: logo dipotong dari artwork **milik project asli**, bukan gambar dari internet.
- `lib/blocs/auth/auth_bloc.dart`, `lib/blocs/auth/auth_event.dart`, `lib/services/local_store.dart`: menghubungkan tombol login/ingat saya dengan sistem autentikasi yang sudah ada.
- `lib/screens/profile_screen.dart` dan `lib/screens/admin_screen.dart`: logout mengembalikan pengguna ke Login secara otomatis lewat `GoRouter`.
- `lib/main.dart`: judul app menjadi `CekBMIku`.

## Cara pemasangan ke project Android Studio yang sudah tersambung GitHub

1. Simpan cadangan project atau buat commit dulu sebelum menimpa file.
2. Ekstrak **CekBMIKu_Login_Gerbang_Update.zip**.
3. Dari hasil ekstrak, salin folder **`lib/`** dan **`assets/`** ke **folder utama project Flutter** yang memuat `pubspec.yaml`; pilih **Replace / Replace existing files**. Jangan menaruhnya di dalam `lib/blocs/auth/`.
4. Pastikan file `lib/services/local_store.dart` berada hanya di **`lib/services/`**, bukan di `lib/blocs/auth/`.
5. Di Terminal Android Studio jalankan:

   ```powershell
   flutter pub get
   flutter analyze
   flutter run
   ```

   Stop lalu **Run ulang** aplikasi (bukan hanya Hot Reload). Tidak perlu `git init` dan tidak perlu mengubah repository GitHub.
6. Sesudah berhasil dijalankan, buka `Git > Commit`, pilih perubahan, commit, lalu push ke repository kamu seperti biasa.

## Alur login

- Saat aplikasi dibuka pertama kali tanpa sesi tersimpan: **Login**.
- Tekan **Daftar** untuk mendaftarkan pengguna, lalu kembali ke Login.
- Akun pengguna terdaftar: login berhasil → **Home**.
- Akun admin demo: `admin@cekbmiku.id` (atau `admin`) / `admin123` → **Dashboard Admin**.
- Logout → **Login** dan menghapus sesi tersimpan.
- **Ingat saya** dicentang → sesi tersimpan di perangkat; tidak dicentang → harus login lagi setelah aplikasi ditutup/dibuka ulang. Saat upgrade dari kode awal, sesi lama direset sekali agar gerbang login berlaku.

## Penting

- Email `admin@cekbmiku.id` pada kolom input adalah **placeholder**, bukan nilai yang otomatis terisi.
- Autentikasi sekarang masih memakai data lokal dan kredensial admin demo; **tidak aman untuk aplikasi produksi**. Untuk aplikasi nyata, gunakan backend autentikasi yang aman dan jangan menyimpan password mentah di SharedPreferences.
- Flutter SDK tidak tersedia di lingkungan penyusunan file ini, sehingga `flutter analyze` dan uji emulator masih perlu dijalankan di komputer kamu. Import relatif dan kecocokan nama fungsi sudah dicek secara statis.
