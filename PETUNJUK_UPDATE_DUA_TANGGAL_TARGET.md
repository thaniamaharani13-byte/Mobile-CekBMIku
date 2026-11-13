# Update form Target BMIku — dua tanggal

Sekarang form terdiri dari **Target Berat Badan (kg)**, **Tanggal Mulai**, dan **Batas Pencapaian Target**, diikuti tombol **Simpan Target**.

- Tanggal Mulai adalah awal periode pemeriksaan yang dipakai untuk menghitung progres.
- Batas Pencapaian Target harus setelah Tanggal Mulai dan tidak boleh di masa lalu.
- Rentang tanggal disimpan secara lokal per akun dan tampil pada halaman ProgressBMIku.
- Jika Tanggal Mulai diubah menjadi tanggal yang sama atau lebih akhir daripada batas sebelumnya, batas dikosongkan untuk dipilih ulang.
- Hasil pemeriksaan di luar kedua tanggal tidak dihitung ke dalam progres periode target. Jika belum ada pemeriksaan dalam rentang, progres menunggu pemeriksaan baru.
- Data target lama tetap bisa dibuka, dengan Tanggal Mulai diambil dari hari target tersebut dibuat.

## Memasang ke project yang sudah ada

1. Ekstrak ZIP update, salin **lib/** ke folder project Flutter dan gabungkan file. Jangan hapus seluruh lib lama.
2. File berubah: `lib/services/goal_store.dart`, `lib/screens/target_bmi_screen.dart`, `lib/screens/home_screen.dart`. Tes opsional: `test/goal_dates_test.dart`.
3. Stop aplikasi lama dan jalankan:

```bash
flutter pub get
flutter analyze
flutter test test/goal_dates_test.dart
flutter run
```

Catatan: Source diperiksa secara struktural, namun build Flutter/emulator harus diuji di komputer pengguna.
