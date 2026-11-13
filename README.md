# CekBMIKu Flutter — Course Aligned Version

Versi ini merupakan refactor dari project CekBMIKu agar sesuai materi kuliah:

- Flutter + Dart
- BLoC / Cubit untuk state management
- `go_router` untuk navigation & routing
- `ShellRoute` untuk persistent bottom navigation
- Nested routing
- Data transit ke detail
- `await context.push<T>()` + `context.pop(result)`
- Redirect / auth guard
- SharedPreferences sebagai local persistence

## Struktur penting

```text
lib/
├── blocs/
│   ├── auth/
│   └── bmi/
├── cubits/
│   ├── admin/
│   ├── article/
│   ├── feedback/
│   ├── profile/
│   └── register/
├── router/
│   ├── app_router.dart
│   └── go_router_refresh_stream.dart
├── screens/
├── services/
├── models/
├── widgets/
└── main.dart
```

## Login admin demo

- username: `admin`
- password: `admin123`

## Cara menjalankan

1. Buka folder project di Android Studio.
2. Jalankan:

```bash
flutter clean
flutter pub get
flutter run
```

3. Pilih emulator Android.

> Jika build gagal karena Java 25 + Gradle 8.x, arahkan Flutter ke JDK 21.

Baca `ARCHITECTURE_NOTES.md` untuk pemetaan konsep materi kuliah ke kode.
