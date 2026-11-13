# Migration Map: Website -> Flutter

| Website lama | Flutter |
|---|---|
| `login.php` + `css/login.css` + `js/login.js` | `lib/screens/login_screen.dart` |
| `register.php` + `css/register.css` | `lib/screens/register_screen.dart` |
| `index.php` | `lib/screens/home_screen.dart` |
| `hasil.php` + `css/hasil.css` | `lib/screens/result_screen.dart` |
| `profile.php` + `css/profile.css` | `lib/screens/profile_screen.dart` |
| `dashboard.php` | `lib/screens/admin_screen.dart` bagian Dashboard |
| `users.php` / `edit_user.php` | `lib/screens/admin_screen.dart` bagian Pengguna |
| `bmi_history.php` | `lib/screens/admin_screen.dart` bagian Riwayat BMI |
| `masukan.php` | `lib/screens/admin_screen.dart` bagian Masukan |
| `articles.php` / `article_edit.php` | `lib/screens/admin_screen.dart` bagian Artikel |
| `faq_admin.php` / `faq_edit.php` | `lib/screens/admin_screen.dart` bagian FAQ |
| `about_admin.php` | `lib/screens/admin_screen.dart` bagian Tentang Kami |
| `koneksi.php` + MySQL | `lib/services/local_store.dart` + SharedPreferences |
| tabel users | `AppUser` |
| tabel hasil_bmi | `BmiResult` |
| tabel masukan | `FeedbackItem` |
| tabel artikel | `ArticleItem` |
| tabel faq | `FaqItem` |
| tabel tentang_kami | `AboutContent` |
| folder `asset/` | `assets/images/` |

## Catatan arsitektur

Konversi ini adalah **native Flutter UI**, bukan WebView. PHP tidak dijalankan di dalam Flutter. Logika yang relevan dipindahkan ke Dart dan data demo disimpan secara lokal.
