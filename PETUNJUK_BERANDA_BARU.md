# Update Beranda CekBMIku — lanjutan Login + Daftar

Sumber: `CekBMIKu_Login_Daftar_Project_Lengkap(1).zip` yang diberikan pengguna. Perubahan tidak menimpa desain Login, Daftar, AuthBloc, atau LocalStore yang sudah ada.

## Perubahan
- `lib/screens/home_screen.dart` — Beranda baru mengikuti referensi: salam, BMI terakhir, CTA, 8 fitur cepat, progres, dan kartu artikel.
- `lib/screens/shell_screen.dart` — Header logo + ikon notifikasi, bottom navigation: Beranda, Kalkulator, Riwayat, Target, Profil.
- `lib/screens/bmi_calculator_screen.dart` — Memindahkan kalkulator asli keluar dari Beranda supaya tetap bisa digunakan.
- `lib/router/app_router.dart` — Rute baru, tetap menjaga login sebagai gerbang ke aplikasi.
- `lib/screens/health_feature_screen.dart` — Halaman Riwayat, Grafik/Progres, Target, Pengingat, Notifikasi, Rekomendasi.
- `lib/services/goal_store.dart` — Penyimpanan target BMI dan preferensi pengingat secara lokal per akun.
- `lib/screens/result_screen.dart` — Tombol Hitung Lagi kembali ke Kalkulator.

## Cara memasang (versi update)
1. Buat cadangan project Android Studio (atau commit Git sebelum mengubah file).
2. Ekstrak `CekBMIKu_Update_Beranda.zip`.
3. Salin folder `lib` ke folder project yang berisi `pubspec.yaml`; gabungkan folder dan **replace** hanya file dengan nama sama.
4. Jangan menaruh `goal_store.dart` di `lib/blocs/auth`. Jalurnya **lib/services/goal_store.dart**.
5. Jangan mengganti `pubspec.yaml`, `main.dart`, folder Android, atau file Login/Daftar.
6. Di Terminal, dari folder utama project, jalankan:

```powershell
flutter pub get
flutter analyze
flutter run
```

Bila SDK tidak tersedia sebagai perintah `flutter`, pakai lokasi SDK yang benar di komputermu (misalnya `& "D:\flutter\bin\flutter.bat" pub get`).

## Alur
Login → Beranda; Daftar → Login → Beranda. Halaman beranda dan seluruh rute internal tetap berada di balik auth guard. Admin demo tetap menuju dashboard admin yang sudah ada.

## Catatan penting
- Angka **24,2** dan tanggal **12 Jan 2026** pada desain adalah contoh. Beranda menampilkan **hasil BMI terakhir milik pengguna yang login**, atau `–` jika belum ada.
- Riwayat dan grafik membaca perhitungan BMI yang disimpan oleh `BmiBloc` dan `LocalStore` lama.
- Target BMI tersimpan lokal pada perangkat; progres diukur dari BMI pertama hingga terakhir dibanding target dan memerlukan setidaknya dua hasil BMI.
- Pengingat **hanya menyimpan preferensi lokal**, belum menjadwalkan push notification/sistem. Notifikasi menampilkan keadaan kosong, bukan notifikasi palsu.
- Artikel mengambil data dari `ArticleCubit`; gambar beranda menggunakan aset lokal yang sudah ada di ZIP.
- Belum diuji dengan Flutter SDK di lingkungan pembuat ZIP; jalankan `flutter analyze` dan pengujian di emulator sebelum push ke GitHub.
