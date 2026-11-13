# Update Halaman Rekomendasi Gaya Hidup — CekBMIku

Versi ini melanjutkan **CekBMIKu_Login_Daftar_Beranda_Fullscreen_Responsive(1).zip** yang diberikan pengguna. Alur Login, Daftar, Beranda, sistem BLoC, BMI, dan navbar utama dipertahankan.

## File yang ditambah dan diubah

| Tindakan | Lokasi dalam project |
|---|---|
| Baru | `lib/screens/lifestyle_recommendations_screen.dart` |
| Baru | `lib/data/lifestyle_tips.dart` |
| Baru | `assets/images/recommendations/` (24 gambar hasil crop dari referensi desain yang diberikan) |
| Diperbarui | `lib/router/app_router.dart` |
| Diperbarui | `lib/screens/health_feature_screen.dart` (menghapus view rekomendasi versi lama, halaman lain tetap) |
| Diperbarui | `pubspec.yaml` (mendaftarkan folder gambar baru) |

## Alur

1. Login -> Daftar jika belum punya akun -> Beranda.
2. Beranda -> **Fitur Cepat > Rekomendasi Gaya Hidup** -> `/recommendations`.
3. Pilih tab **Makanan** (4 item), **Aktivitas Fisik** (10 item), **Gaya Hidup** (10 item).
4. Gunakan panah kembali menuju Beranda. Halaman Rekomendasi tanpa bottom navbar supaya sesuai desain referensi, tetapi navbar Beranda/halaman utama tetap fixed ketika scroll.

**Kategori BMI Kamu** membaca riwayat akun dari `ProfileCubit`; jika belum ada riwayat maka muncul `Belum ada data`, bukan menampilkan BMI Normal contoh. Saran bersifat umum untuk prototipe dan tidak diklaim personal untuk tiap kategori BMI.

## Cara memasang paket Update

1. Ekstrak ZIP **Update_Rekomendasi**.
2. Cadangkan atau commit project sebelum mengganti file.
3. Gabungkan folder `lib/` dan `assets/` ke folder utama Flutter yang memiliki `pubspec.yaml`. Pilih **Replace** untuk file yang sudah ada.
4. Ganti juga **`pubspec.yaml`** dari paket update agar `assets/images/recommendations/` terdaftar.
5. Pastikan jangan menyalin `lifestyle_tips.dart` atau `lifestyle_recommendations_screen.dart` ke folder lain; path harus sesuai di tabel.
6. Di Terminal Android Studio jalankan:

```powershell
flutter pub get
flutter analyze
flutter run
```

Stop dan Run ulang aplikasi; hot reload saja kadang tidak memuat asset baru atau konfigurasi router awal.

## Catatan penting

- Ada 24 foto kecil hasil crop dari gambar desain yang diberikan; kualitas gambar cukup untuk thumbnail UI, bukan untuk layar penuh.
- Tidak menambahkan dependency Flutter baru.
- Tidak mengubah pengaturan immersive/fullscreen yang sudah ada dalam project dasar.
- `flutter analyze` dan build Android belum dijalankan di lingkungan penyusunan karena Flutter SDK tidak tersedia. Periksa di Android Studio sebelum commit/push.
