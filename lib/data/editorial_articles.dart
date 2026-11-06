import '../models/models.dart';

/// Katalog editorial sesuai desain UI Semua Artikel. Konten dan tanggal
/// adalah materi contoh prototipe, bukan hasil pengambilan data online.
class EditorialEntry {
  const EditorialEntry({required this.article, required this.published, required this.readTime});
  final ArticleItem article;
  final String published;
  final String readTime;
}

const editorialArticles = <EditorialEntry>[
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-01', title: 'Tips Menjaga Berat Badan Ideal Sepanjang Tahun',
      description: 'Menjaga berat badan ideal bukan hanya soal penampilan, tetapi juga berpengaruh pada kesehatan jangka panjang Anda.',
      image: 'assets/images/editorial/article_01.jpg', category: 'Nutrisi',
    ),
    published: '12 Jan 2026', readTime: '4 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-02', title: 'Olahraga 30 Menit Sehari untuk BMI Lebih Sehat',
      description: 'Aktivitas fisik rutin terbukti membantu menjaga indeks massa tubuh dalam rentang normal.',
      image: 'assets/images/editorial/article_02.jpg', category: 'Olahraga',
    ),
    published: '12 Jan 2026', readTime: '5 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-03', title: 'Memahami Angka BMI dan Artinya bagi Tubuhmu',
      description: 'Kenali rentang BMI dan mengapa angka ini bukan satu-satunya ukuran kesehatan.',
      image: 'assets/images/editorial/article_03.jpg', category: 'BMI',
    ),
    published: '11 Jan 2026', readTime: '4 menit baca',
  ),
];
