# Architecture Justification

## Mengapa BLoC untuk Auth dan BMI?

Auth dan perhitungan BMI memiliki alur yang jelas: **event -> processing -> state**. Keduanya juga memiliki kemungkinan loading, success, dan failure, sehingga BLoC cocok untuk membuat alur dapat diprediksi dan mudah ditelusuri.

## Mengapa Cubit untuk state lain?

Registrasi, profil, artikel, feedback, dan admin relatif lebih sederhana. Cubit digunakan untuk mengurangi boilerplate tetapi tetap menjaga pemisahan state dari UI.

## Mengapa go_router?

Aplikasi memiliki banyak halaman, detail, route terlindungi, dan bottom navigation. `go_router` membuat routing deklaratif dan memungkinkan:

- path parameter,
- nested route,
- redirect/auth guard,
- `ShellRoute`,
- data transit,
- back stack melalui `push`,
- perpindahan root melalui `go`.

## Mapping domain CekBMIKu ke contoh materi

Materi mencontohkan tiga tab `Home`, `Katalog`, `Profil`. Karena domain CekBMIKu tidak memiliki katalog produk, tab `Katalog` dipetakan menjadi `Artikel` tetapi pola navigasinya tetap sama.
