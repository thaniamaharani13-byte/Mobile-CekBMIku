# Revisi Tombol Pria/Wanita pada Kalkulator CekBMIku

## Penyebab hasil tampak sama
Versi sebelumnya menggunakan `item.gender` dan `item.idealWeight` dari hasil BMI yang tersimpan untuk menampilkan Broca. Saat tombol Pria/Wanita dipilih, state tombol memang berubah, tetapi kartu hasil masih memakai nilai lama.

## Perbaikan
- Tombol Pria menggunakan `(TB - 100) - 10% × (TB - 100)`.
- Tombol Wanita menggunakan `(TB - 100) - 15% × (TB - 100)`.
- Kartu pratinjau Broca langsung berubah ketika tombol dipilih dan tinggi badan sudah diisi.
- Setelah tombol **Hitung BMI & Broca** ditekan, `BmiBloc` menghitung ulang berdasarkan `gender` terbaru, lalu menyimpan hasil ke riwayat pengguna.
- Kartu hasil Broca juga selalu membaca pilihan tombol saat ini, tidak lagi `gender` dari riwayat lama.
- BMI biasa tetap memakai `berat / (tinggi dalam meter)^2` sehingga nilai BMI tidak berbeda berdasarkan gender untuk tinggi dan berat yang sama.

## Instalasi update ke project yang sudah ada
1. Hentikan aplikasi yang sedang berjalan di Android Studio. Buat commit/backup terlebih dahulu.
2. Ekstrak ZIP update, lalu salin file berikut ke lokasi yang sama dalam project kamu:
   - `lib/core/broca_calculator.dart` **(file baru)**
   - `lib/blocs/bmi/bmi_bloc.dart` **(ganti)**
   - `lib/screens/bmi_calculator_screen.dart` **(ganti)**
   - `test/broca_calculator_test.dart` **(opsional, untuk pengujian)**
3. Jangan membuat duplikat file atau mengganti seluruh folder `lib`.
4. Dari folder project (tempat `pubspec.yaml`), jalankan:

```powershell
flutter pub get
flutter analyze
flutter test test/broca_calculator_test.dart
flutter run
```

5. Jalankan ulang aplikasinya, **bukan hanya Hot Reload**, terutama jika ada cache hasil lama.

## Cara cek hasil perhitungan
Masukkan **Tinggi 170 cm** dan **Berat 70 kg**.

| Pilihan | BMI standar | Estimasi Broca |
| --- | --- | --- |
| Pria | 24,2 | 63,0 kg |
| Wanita | 24,2 | 59,5 kg |

Setelah memilih gender, angka pada bagian **Estimasi langsung** akan berubah. Klik **Hitung BMI & Broca** untuk menyimpan hasil dengan pilihan terbaru.

Jika hasil di emulator masih sama persis, pastikan file yang diganti berada di project aktif, bukan folder ZIP lain; lalu Stop dan Run ulang.

> Rumus Broca adalah perkiraan kasar bagi orang dewasa, bukan diagnosis maupun target berat yang cocok bagi semua orang.
