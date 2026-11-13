# Update Kalkulator BMI: Rumus Broca (Pria dan Wanita)

Paket ini dibuat berdasarkan project **CekBMIKu_Tanpa_Artikel_Olahraga_Beranda.zip**. Perubahan hanya mencakup dua file:

1. `lib/blocs/bmi/bmi_bloc.dart` — memperjelas perhitungan Broca yang sebenarnya sudah tersedia sebelumnya.
2. `lib/screens/bmi_calculator_screen.dart` — menampilkan hasil, rumus, dan selisih berat saat ini terhadap estimasi Broca dalam kartu terpisah setelah hasil BMI.

## Perhitungan

- **Pria:** `(tinggi_cm - 100) - 0.10 * (tinggi_cm - 100)`
- **Wanita:** `(tinggi_cm - 100) - 0.15 * (tinggi_cm - 100)`
- Contoh 170 cm: **pria 63,0 kg**, **wanita 59,5 kg**.

Jenis kelamin mengikuti pilihan **Pria/Wanita** ketika tombol **Hitung BMI** ditekan, dan kartu menggunakan hasil yang disimpan untuk pemeriksaan tersebut (bukan pilihan yang mungkin baru diganti setelahnya).

**Catatan kesehatan:** Broca hanya perkiraan sederhana untuk orang dewasa dan bukan target personal atau diagnosis. BMI juga merupakan indikator skrining, bukan diagnosis.

## Memasang paket update

1. Buat backup atau commit di project Android Studio.
2. Ekstrak `CekBMIKu_Update_Kalkulator_Broca.zip`.
3. Salin kedua file dalam folder `lib` dari paket ke lokasi yang sama di project yang aktif (gabungkan folder; jangan hapus seluruh `lib`).
4. Stop aplikasi yang sedang berjalan, lalu jalankan:

```powershell
flutter pub get
flutter analyze
flutter run
```

Tidak ada package baru maupun perubahan `pubspec.yaml`. Jika kamu memakai versi kode berbeda, periksa perbedaan kedua file sebelum Replace.

## Pengujian

1. Pilih **Pria**, isi tinggi **170** cm dan berat **70** kg, lalu tekan **Hitung BMI**. Estimasi Broca seharusnya **63,0 kg** (selisih **7,0 kg**).
2. Pilih **Wanita** dan hitung ulang dengan input sama. Estimasi Broca seharusnya **59,5 kg** (selisih **10,5 kg**).
3. Pastikan hasil BMI yang dihitung tetap **24,2** (pembulatan satu desimal), sesuai rumus BMI yang lama.
4. Pastikan pilihan Pria/Wanita disimpan bersama hasil sehingga label dan estimasinya sesuai ketika aplikasi dibuka kembali.
5. Periksa bahwa halaman Beranda tetap **tidak** menampilkan kartu artikel olahraga redundan yang sebelumnya dihapus.

**Verifikasi:** Struktur berkas, rujukan import lokal, dan hitungan contoh diperiksa secara statis. Build/emulator belum dijalankan di sini karena Flutter SDK tidak tersedia pada lingkungan ini.
