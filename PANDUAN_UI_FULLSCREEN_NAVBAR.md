# CekBMIku — Tampilan penuh & navbar tetap

Versi ini melanjutkan **project Login + Daftar + Beranda**, bukan versi `codetea` / project terpadu lainnya.

## Perubahan

1. `lib/main.dart`: Mencoba menyembunyikan **status bar perangkat** (jam, baterai, sinyal) dan **navigation bar/home indicator sistem** lewat `SystemUiMode.immersiveSticky` di seluruh halaman. Setelah keyboard ditutup, mode layar penuh dicoba lagi. Saat aplikasi dibuka kembali, mode layar penuh juga diatur ulang.
2. `lib/screens/shell_screen.dart`: Navbar bawah tetap berada di `Scaffold.bottomNavigationBar`, **di luar area konten scroll**, dengan ukuran ikon/teks dan jarak yang menyesuaikan lebar layar. Navigasi tetap Beranda, Kalkulator, Riwayat, Target, dan Profil.
3. `lib/screens/home_screen.dart`: Fitur Cepat menjadi 2 kolom pada HP sangat sempit dan 4 kolom pada ukuran normal; tinggi item dijaga agar teks tidak terpotong saat scroll.
4. `android/app/src/main/res/values-v35/styles.xml` dan `values-night-v35/styles.xml`: Opsi untuk perangkat Android 15 agar mode selain edge-to-edge dapat dipakai pada konfigurasi target SDK yang mendukung.
5. `android/app/src/main/res/values-v36/styles.xml` dan `values-night-v36/styles.xml`: Tidak memuat opsi terlarang Android 16.

## Cara update project Android Studio yang sudah ada

1. Buat backup atau Git commit untuk project yang berfungsi.
2. Ekstrak `CekBMIKu_Update_Fullscreen_Navbar.zip`.
3. Salin folder `lib/` dan `android/` dari paket update ke folder utama project (yang memiliki `pubspec.yaml`). Pilih **Replace** hanya pada file yang sama.
4. Buka Terminal pada folder utama project dan jalankan:

   ```sh
   flutter pub get
   flutter analyze
   flutter run
   ```

5. **Stop dan Run ulang** aplikasi. Jika menguji perubahan XML Android pada perangkat, lakukan build ulang (bukan hot reload). Tes dengan layar sempit dan tinggi berbeda.

## Catatan penting

- Angka jam dan indikator baterai di atas serta garis gestur hitam di bawah adalah bagian **UI milik Android/iOS**, bukan widget yang digambar halaman Flutter. `SystemUiMode.immersiveSticky` hanya meminta sistem menyembunyikannya pada platform yang mendukung.
- **Android 16 / target API 36+** memaksa *edge-to-edge* dan dapat mengabaikan permintaan menyembunyikan bilah sistem. Pada sistem tersebut bilah bisa tetap terlihat. Navbar aplikasi tetap berada di atas *safe area* sehingga tidak tertabrak indikator navigasi OS.
- Saat keyboard terbuka, sistem dapat memunculkan bilah sementara. Aplikasi meminta kembali mode fullscreen setelah keyboard ditutup; mungkin ada jeda singkat.
- Navbar bawah **tidak** ditampilkan pada halaman Login dan Daftar, sesuai desain; baru muncul setelah login pada halaman yang menggunakan `ShellRoute`.
- Tidak ada perubahan pada login, penyimpanan BMI, registrasi, atau data.
- Struktur file, impor lokal, dan XML sudah diperiksa secara statis, tetapi tidak diuji build/emulator karena Flutter SDK tidak tersedia di lingkungan ini.

Dokumentasi: https://api.flutter.dev/flutter/services/SystemUiMode.html dan https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge
