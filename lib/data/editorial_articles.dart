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
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-04', title: 'Isi Piringku: Panduan Porsi Makan Seimbang',
      description: 'Atur porsi karbohidrat, protein, sayur, dan buah tanpa perlu diet ketat.',
      image: 'assets/images/editorial/article_04.jpg', category: 'Nutrisi',
    ),
    published: '11 Jan 2026', readTime: '5 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-05', title: 'Mulai Jalan Kaki, Mulai Kebiasaan Sehat',
      description: 'Langkah sederhana untuk lebih aktif, dari perjalanan singkat hingga jalan pagi.',
      image: 'assets/images/editorial/article_05.jpg', category: 'Olahraga',
    ),
    published: '10 Jan 2026', readTime: '3 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-06', title: 'Sudah Cukup Minum Air Putih Hari Ini?',
      description: 'Pahami kebutuhan cairan dan tanda tubuh yang mulai kekurangan air.',
      image: 'assets/images/editorial/article_06.jpg', category: 'Kesehatan',
    ),
    published: '10 Jan 2026', readTime: '3 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-07', title: 'Tidur Cukup Bantu Menjaga Berat Badan',
      description: 'Kualitas tidur ikut memengaruhi rasa lapar, energi, dan kebiasaan makanmu.',
      image: 'assets/images/editorial/article_07.jpg', category: 'Kesehatan',
    ),
    published: '9 Jan 2026', readTime: '4 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-08', title: 'Sumber Protein Sehat yang Mudah Ditemukan',
      description: 'Dari tempe hingga telur, lengkapi menu harian dengan pilihan protein bergizi.',
      image: 'assets/images/editorial/article_08.jpg', category: 'Nutrisi',
    ),
    published: '9 Jan 2026', readTime: '4 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-09', title: 'Peregangan Ringan di Sela Kesibukan',
      description: 'Luangkan beberapa menit untuk mengurangi kaku setelah duduk terlalu lama.',
      image: 'assets/images/editorial/article_09.jpg', category: 'Olahraga',
    ),
    published: '8 Jan 2026', readTime: '3 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-10', title: 'Kapan Waktu Terbaik Menimbang Berat Badan?',
      description: 'Gunakan cara yang konsisten agar perubahan berat badan lebih mudah dipantau.',
      image: 'assets/images/editorial/article_10.jpg', category: 'BMI',
    ),
    published: '8 Jan 2026', readTime: '3 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-11', title: 'Tambah Serat, Kenyang Lebih Lama',
      description: 'Buah, sayur, dan biji-bijian membantu pencernaan sekaligus melengkapi gizimu.',
      image: 'assets/images/editorial/article_11.jpg', category: 'Nutrisi',
    ),
    published: '7 Jan 2026', readTime: '4 menit baca',
  ),
  EditorialEntry(
    article: ArticleItem(
      id: 'editorial-12', title: 'Bangun Kebiasaan Sehat, Satu Langkah Dulu',
      description: 'Mulai dari target kecil yang realistis agar rutinitas sehat lebih mudah dijaga.',
      image: 'assets/images/editorial/article_12.jpg', category: 'Kesehatan',
    ),
    published: '7 Jan 2026', readTime: '5 menit baca',
  ),
];
