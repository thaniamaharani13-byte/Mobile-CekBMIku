# AI Navigation Diagnostics

## Kasus

Saat detail artikel hanya bergantung pada `state.extra`, membuka URL `/articles/a1` secara langsung dapat menghasilkan artikel tidak ditemukan karena `extra` hanya tersedia ketika halaman dibuka dari list.

## Diagnosis

Route sudah memiliki path parameter `:articleId`, tetapi implementasi awal terlalu bergantung pada object yang dikirim dari halaman sebelumnya.

## Perbaikan

`ArticleDetailScreen` sekarang menerima:

- `articleId` dari path parameter sebagai sumber identitas utama,
- `initialArticle` dari `state.extra` sebagai data transit cepat.

Jika `initialArticle` tidak tersedia, detail menunggu `ArticleCubit` selesai memuat data lalu mencari artikel berdasarkan `articleId`.

Dengan cara ini:

- navigasi dari ListView tetap menggunakan data transit,
- deep link/path langsung tetap dapat dipulihkan,
- route tidak bergantung sepenuhnya pada state layar sebelumnya.
