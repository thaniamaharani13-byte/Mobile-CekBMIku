# Update Target BMIku & ProgressBMIku

Paket ini dibuat dari **CekBMIKu_Login_Daftar_Beranda_Rekomendasi_Artikel_Notifikasi_Kalkulator_Riwayat_Lengkap(1).zip** yang diberikan pengguna.

## Apa yang berubah

- Navbar bagian bawah tetap berada di `ShellScreen`, sehingga tidak ikut tergulir.
- Menu **Target** dan kartu progres Beranda terhubung ke layar baru Target BMIku/ProgressBMIku.
- Di **Target BMIku** ada pilihan target berat badan atau nilai BMI, formulir, tanggal target menggunakan date picker, simpan target, dan ringkasan progres.
- Di **ProgressBMIku** ada indikator progres melingkar, statistik nilai terkini/target/selisih, informasi target, grafik BMI dengan garis target, dan pesan motivasi.
- Data target disimpan per email akun pada `SharedPreferences`. Nilai hasil BMI, berat, tanggal pemeriksaan, dan perkembangan grafik diambil dari riwayat aktual. Tampilan kosong disediakan saat datanya belum ada.
- Saat pertama kali membuat target, kemajuan dimulai dari nilai pemeriksaan terbaru yang sudah tersimpan; setelah ada pemeriksaan baru, persentase dihitung berdasarkan perubahan ke arah target. Jika belum pernah memeriksa BMI, pengukuran pertama setelah membuat target menjadi titik awal.
- `GoalStore.getGoal` / `setGoal` versi lama tetap tersedia agar halaman lain tidak kehilangan dependensinya. Target BMI lama dapat dibaca sebagai target sebelumnya.

## File yang diperbarui

1. `lib/services/goal_store.dart` — model target dan penyimpanan per akun.
2. `lib/screens/target_bmi_screen.dart` — **file baru**: halaman Target & Progres.
3. `lib/router/app_router.dart` — `/target` dan `/progress` diarahkan ke layar baru.
4. `lib/screens/shell_screen.dart` — header sesuai tab aktif dan tab Target menyala juga pada Progress.
5. `lib/screens/home_screen.dart` — ringkasan Beranda memakai progres dari target yang sama.

## Memasang paket Update

1. Buat salinan proyek atau commit Git cadangan terlebih dahulu.
2. Ekstrak ZIP update. **Salin folder `lib` dan gabungkan** dengan folder `lib` proyek yang memiliki `pubspec.yaml`; pilih Replace untuk file bernama sama. Jangan menghapus folder `lib` lama.
3. Tidak ada perubahan pada `pubspec.yaml` atau file platform Android/iOS. Tidak perlu menambah package.
4. Buka Android Studio, pastikan folder proyek yang dijalankan benar, lalu jalankan:

```powershell
flutter pub get
flutter analyze
flutter run
```

5. Stop aplikasi lama sebelum run ulang (jangan hanya Hot Reload).

## Uji alur

- Login → Beranda → navbar **Target** → pilih Berat Badan → masukkan target valid → pilih tanggal → **Simpan Target**.
- Pindah tab **ProgressBMIku** → ringkasan target dan grafik tampil.
- Coba target **BMI** dan ubah tanggal lalu Simpan.
- Lakukan perhitungan BMI baru dari tab Kalkulator, lalu periksa apakah hasil dan progres diperbarui.
- Di Beranda, tekan **Progres Menuju Target**: layar Progres harus terbuka.
- Coba Logout/Login akun lain; target harus dipisahkan per akun.

## Batasan

- Data disimpan lokal di perangkat, bukan cloud/database server.
- Grafik mengikuti pemeriksaan asli dan tidak mengisi bulan yang kosong dengan nilai tiruan.
- Persentase hanya bertambah jika pengukuran bergerak menuju target, bukan otomatis karena waktu berlalu. Ini **indikator pencapaian target pribadi**, bukan rekomendasi medis.
- Fullscreen mengikuti pengaturan lama pada project; OS Android terbaru dapat menolak permintaan menyembunyikan bilah sistem.
- Build belum diuji dalam emulator pada lingkungan pembuatan file ini (Flutter SDK tidak tersedia). Jalankan `flutter analyze` dan uji manual di Android Studio.
