# AI Review Summary — CekBMIKu

## Hasil review arsitektur

1. **Pemisahan UI dan business logic**
   - Perhitungan BMI, validasi input, dan penyimpanan riwayat berada di `BmiBloc`.
   - Login/logout berada di `AuthBloc`.
   - Registrasi, profil, artikel, feedback, dan admin memakai Cubit sesuai kompleksitas state.
   - Widget fokus pada input pengguna, trigger event/method, dan render state.

2. **State immutable**
   - State dibuat sebagai object baru saat terjadi perubahan.
   - State menggunakan `Equatable` untuk perbandingan state yang konsisten.

3. **One-time action**
   - `BlocListener` dipakai untuk SnackBar, pop, dan respons sukses/gagal.
   - `BlocConsumer` dipakai pada kalkulator BMI karena layar perlu rebuild sekaligus menjalankan navigation side effect.

4. **Navigation**
   - `MaterialApp.router` + `go_router` menggantikan `Navigator.push(MaterialPageRoute(...))`.
   - `ShellRoute` mempertahankan bottom navigation.
   - `context.go()` dipakai untuk perpindahan tab/root.
   - `context.push()` dipakai untuk detail/form agar history/back stack tetap ada.

5. **Auth guard**
   - `/profile` dan semua sub-route di bawahnya dilindungi redirect.
   - `/admin` hanya dapat diakses saat state autentikasi admin aktif.

6. **Data transit + boomerang effect**
   - `ArticleItem` dikirim ke detail melalui `state.extra`.
   - Detail mengembalikan `bool` status favorit menggunakan `context.pop(result)`.
   - List menunggu hasil menggunakan `await context.push<bool>()`.

## Catatan

`SharedPreferences` tetap dipakai sebagai local persistence supaya project mudah dijalankan tanpa server. Untuk aplikasi produksi, repository dapat diarahkan ke API/SQLite tanpa mengubah UI secara besar karena state management sudah dipisahkan.
