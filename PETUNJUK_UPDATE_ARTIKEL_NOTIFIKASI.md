# CekBMIku — Update Semua Artikel & Notifikasi

## Basis
Paket dibuat dari `CekBMIKu_Login_Daftar_Beranda_Rekomendasi_Lengkap(1).zip` yang diberikan. Fitur Login, Daftar, Beranda, rekomendasi, kalkulator, dan navbar sebelumnya dipertahankan.

## Pemasangan ke project yang sudah ada
1. Buat cadangan/commit project aktif.
2. Ekstrak `CekBMIKu_Update_Artikel_Notifikasi.zip`.
3. Dari hasil ekstrak, salin folder **lib** dan **assets** ke root project Flutter lama (sejajar dengan `pubspec.yaml`), pilih *Merge/Replace* pada file yang sama.
4. Ganti juga `pubspec.yaml` dengan versi paket (hanya penambahan asset `assets/images/editorial/`). Bila `pubspec.yaml` lokal pernah dimodifikasi, cukup tambahkan deklarasi asset tersebut secara manual dan pertahankan dependency lain.
5. Di Terminal Android Studio pada root project: `flutter pub get`, lalu `flutter analyze`, dan `flutter run`. Stop aplikasi sebelumnya dan jalankan ulang (bukan hot reload).

## Alur navigasi
- **Beranda > Artikel Terbaru > Lihat Semua** membuka `/articles` (halaman mandiri tanpa navbar bawah).
- Dari setiap kartu artikel bisa masuk ke `/articles/:articleId` dan kembali dengan tombol belakang. Status favorit disimpan oleh `ArticleCubit` lama.
- **Beranda > ikon lonceng** membuka `/notifications` (halaman mandiri tanpa navbar bawah).
- Notifikasi contoh memiliki 2 yang belum dibaca, tanda titik biru, hapus per kartu, hapus semua, dan layar kosong. Tap kartu = tandai dibaca.

## Data prototipe
- Daftar 12 artikel, ringkasan, tanggal terbit dan waktu baca mengikuti desain. Foto kecil dipotong dari gambar UI yang pengguna berikan, disimpan lokal sebagai `assets/images/editorial/` agar tidak membutuhkan internet.
- Notifikasi merupakan **contoh data lokal**, bukan push notification Android atau notifikasi terjadwal. Notifikasi awal dibentuk sekali per akun dan disimpan melalui `shared_preferences`; setelah dihapus tidak muncul lagi saat halaman dibuka ulang. Teks BMI/target akan membaca data yang tersedia (jika tidak ada, ditampilkan ajakan melakukan pemeriksaan, bukan hasil BMI palsu).
- Hasil BMI dan target yang berubah **tidak otomatis memicu notifikasi baru** dalam versi ini. Pengingat sistem/terjadwal memerlukan integrasi lanjutan.
- Tahun artikel mengikuti contoh desain Januari 2026, bukan klaim konten online baru.

## File yang diubah
- `lib/screens/home_screen.dart` (artikel unggulan sesuai katalog)
- `lib/screens/article_screen.dart` (desain Semua Artikel)
- `lib/screens/article_detail_screen.dart` (fallback katalog)
- `lib/router/app_router.dart` (route Artikel & Notifikasi tanpa navbar)
- `pubspec.yaml` (daftarkan aset editorial)

## File yang ditambah
- `lib/data/editorial_articles.dart` (12 artikel)
- `lib/screens/notifications_screen.dart` (desain terisi & kosong)
- `lib/services/notification_store.dart` (notifikasi lokal per akun)
- `assets/images/editorial/article_01.jpg` sampai `article_12.jpg`

## Status pemeriksaan
Import relatif, path aset, deklarasi aset dan route diperiksa secara statis. Proses `flutter analyze`/build emulator **belum dijalankan** dalam lingkungan pembuatan paket karena Flutter SDK tidak tersedia.
