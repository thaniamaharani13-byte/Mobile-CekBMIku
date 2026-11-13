# Update Profil + Pengingat BMI — CekBMIku

## Yang diperbarui

- `lib/screens/profile_screen.dart` — Profil sesuai desain: nama/email dari akun, avatar opsional dari galeri, menu Pengaturan Profil, Pengaturan Notifikasi, logout. Header + navbar utama tetap berasal dari `ShellScreen`.
- `lib/screens/bmi_reminder_screen.dart` — dua status pengingat, pilihan waktu lokal, dialog Izinkan/Nanti, status izin sistem, jadwal berikutnya dan tips.
- `lib/services/bmi_reminder_service.dart` — pengingat mingguan Android/iOS melalui local notifications, simpan pilihan per akun dengan SharedPreferences.
- `lib/router/app_router.dart` — `/reminders` ditampilkan sebagai halaman berdiri sendiri **tanpa** navbar utama.
- `lib/screens/shell_screen.dart` — ikon lonceng pada header Profil; navbar lainnya tidak berubah.
- `lib/cubits/register/register_cubit.dart` — tanggal pertama daftar disimpan untuk label keanggotaan Profil baru; akun lama hanya menampilkan label umum tanpa tanggal palsu.
- `pubspec.yaml` — tambahan `flutter_local_notifications`, `flutter_timezone`, `timezone`, `image_picker`, `path_provider`.
- `android/app/build.gradle.kts` — min SDK, compile SDK 35, desugaring untuk notifikasi terjadwal.
- `android/app/src/main/AndroidManifest.xml` — izin notifikasi, boot dan receiver pengingat terjadwal.

## Cara memasang ZIP update

1. Backup atau commit project Android Studio sekarang.
2. Ekstrak ZIP update.
3. Gabungkan folder `lib` dan `android` ke project Flutter sekarang. **Replace file yang namanya sama**, jangan hapus seluruh folder `lib`.
4. Gabungkan `pubspec.yaml` (jika tidak ada perubahan dependency milikmu, boleh Replace langsung).
5. **Stop** aplikasi yang sedang berjalan, lalu jalankan:

```powershell
flutter pub get
flutter analyze
flutter run
```

6. Menu Profil (navbar) → Pengaturan Notifikasi → pilih waktu → aktifkan → popup Izinkan → izin sistem Android bila diminta. Uji juga switch mati/aktif, tombol Nanti, dan Ubah Profil.

## Catatan teknis dan kejujuran pengujian

- Pengingat yang dijadwalkan oleh OS berbeda dari contoh notifikasi yang ditampilkan di halaman `/notifications` (daftar itu masih menggunakan data contoh lokal dari project sebelumnya).
- Pengingat diatur mingguan pada hari saat pertama kali diaktifkan. Jika waktu diubah, jadwal di hari yang sama diperbarui.
- Jadwal menggunakan mode **inexact** agar tidak perlu izin `SCHEDULE_EXACT_ALARM` khusus; notifikasi bisa muncul sedikit lebih lambat sesuai kebijakan perangkat. Penghematan baterai dan pengaturan pabrikan juga memengaruhi pengiriman.
- Khusus Android 13+, pengguna harus memberikan izin `POST_NOTIFICATIONS`. Jika sebelumnya ditolak permanen, izin mungkin harus diaktifkan lewat Settings aplikasi di perangkat.
- File `pubspec.yaml` menggunakan `flutter_local_notifications: ^19.5.0` untuk kompatibilitas Flutter 3.22+ (bukan 21+/22+ yang menuntut SDK lebih baru). Jalankan `flutter --version` bila dependensi tidak bisa diunduh.
- Belum diuji dengan `flutter run` pada perangkat karena Flutter SDK/emulator tidak tersedia di lingkungan pembuatan. Struktur file, dependency, import lokal, dan AndroidManifest telah diperiksa secara statis; uji dengan perintah di atas sebelum commit GitHub.
- Sistem registrasi dalam project dasar masih lokal dan menyimpan kredensial dalam perangkat. Ini cocok untuk prototipe tugas, **bukan** sistem login produksi.
- Avatar galeri disimpan sebagai berkas aplikasi lokal (bukan upload server). Hanya akun dan perangkat tersebut yang melihatnya.
- Versi ZIP ini tidak berisi project iOS; pengguna iOS harus membuat platform iOS dan menambahkan keterangan izin foto serta konfigurasi notifikasi sesuai plugin.
