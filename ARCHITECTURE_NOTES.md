# CekBMIKu — Penyesuaian dengan Materi Kuliah

Project ini sengaja disusun untuk menunjukkan konsep pada materi **State Management Masterclass** dan **Modern Flutter Navigation**.

## 1. State Management

### BLoC event-driven
- `AuthBloc`: event login/logout/app-start -> state authentication.
- `BmiBloc`: event `BmiCalculateRequested` -> validasi, perhitungan, penyimpanan -> state success/failure.
- Business logic BMI tidak berada di `Widget build()`.

### Cubit untuk state yang lebih sederhana
- `RegisterCubit`
- `ProfileCubit`
- `ArticleCubit`
- `FeedbackCubit`
- `AdminCubit`

### UI hanya trigger dan render
- `BlocBuilder` untuk menggambar state.
- `BlocListener` untuk aksi satu kali seperti SnackBar/navigation.
- `BlocConsumer` pada kalkulator BMI karena perlu build + listener.

## 2. Navigation & Routing

### `MaterialApp.router`
Gateway aplikasi menggunakan router declarative.

### `go_router`
Route utama:
- `/home`
- `/articles`
- `/profile`
- `/login`
- `/register`
- `/result`
- `/admin`

### Persistent Shell
`ShellRoute` mempertahankan `NavigationBar` pada tab:
1. Home
2. Artikel
3. Profil

### `go()` vs `push()`
- `context.go()` untuk pindah tab/root route.
- `context.push()` untuk layar detail/form yang perlu tombol Back.

### Nested Route
- `/articles/:articleId`
- `/profile/edit`
- `/profile/feedback`

### Data Transit
`ArticleItem` dikirim ke detail dengan `extra` dan disuntikkan ke konstruktor `ArticleDetailScreen`.

### Boomerang Effect
Daftar artikel menunggu:

```dart
final favoriteResult = await context.push<bool>(
  '/articles/${article.id}',
  extra: article,
);
```

Detail mengembalikan status:

```dart
context.pop(true);
```

### Auth Guard
Route `/profile...` dilindungi `redirect`. User yang belum login diarahkan ke `/login?redirect=...` dan kembali ke route semula setelah login.

## 3. Penyimpanan

Masih menggunakan `SharedPreferences` agar project mudah dijalankan untuk tugas kuliah tanpa server.

## 4. Menjalankan

```bash
flutter clean
flutter pub get
flutter run
```

Jika Java 25 menyebabkan Gradle gagal, gunakan JDK 21 untuk Flutter/Gradle.
