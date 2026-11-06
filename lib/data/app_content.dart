import '../models/models.dart';

const aboutTitle = 'Tentang CekBMIKu';
const aboutOpening =
    'CekBMIKu membantu pengguna mengetahui indeks massa tubuh dengan cepat dan memahami kondisi berat badan melalui informasi yang sederhana.';
const aboutGoal =
    'Membantu pengguna memantau kondisi berat badan, menyimpan riwayat pengecekan, serta memperoleh edukasi dasar mengenai pola hidup sehat.';
const aboutFeatures =
    'Kalkulator BMI, estimasi berat ideal, riwayat hasil, rekomendasi makanan dan vitamin, artikel kesehatan, FAQ, profil, serta masukan pengguna.';

const defaultFaqs = <FaqItem>[
  FaqItem(
    id: 'faq1',
    question: 'Apa itu BMI?',
    answer: 'BMI atau Body Mass Index adalah perbandingan berat badan dan tinggi badan yang digunakan sebagai indikator umum status berat badan orang dewasa.',
  ),
  FaqItem(
    id: 'faq2',
    question: 'Bagaimana cara menghitung BMI?',
    answer: 'BMI dihitung dengan rumus berat badan dalam kilogram dibagi kuadrat tinggi badan dalam meter.',
  ),
  FaqItem(
    id: 'faq3',
    question: 'Apakah BMI merupakan diagnosis kesehatan?',
    answer: 'Tidak. BMI merupakan indikator skrining umum dan bukan pengganti pemeriksaan atau diagnosis dari tenaga kesehatan.',
  ),
  FaqItem(
    id: 'faq4',
    question: 'Mengapa hasil BMI perlu disimpan?',
    answer: 'Riwayat membantu pengguna melihat perubahan BMI dari waktu ke waktu sehingga perkembangan dapat dipantau dengan lebih mudah.',
  ),
];

const defaultArticles = <ArticleItem>[
  ArticleItem(
    id: 'a1',
    title: 'Cara Sehat Menaikkan Berat Badan',
    description: 'Fokus pada asupan bergizi padat energi, protein cukup, pola makan teratur, tidur yang baik, dan latihan kekuatan secara bertahap.',
    image: 'assets/images/articles/kurus1.jpg',
    category: 'Kurus',
  ),
  ArticleItem(
    id: 'a2',
    title: 'Menjaga Berat Badan Tetap Ideal',
    description: 'Pertahankan pola makan seimbang, aktivitas fisik rutin, cukup tidur, hidrasi, serta pemantauan berat badan secara berkala.',
    image: 'assets/images/articles/normal1.jpg',
    category: 'Normal',
  ),
  ArticleItem(
    id: 'a3',
    title: 'Langkah Awal Mengelola Berat Badan Berlebih',
    description: 'Mulai dari perubahan kecil yang konsisten seperti mengatur porsi, memperbanyak sayur, memilih sumber protein, dan bergerak lebih aktif.',
    image: 'assets/images/articles/kelebihan1.png',
    category: 'Kelebihan Berat Badan',
  ),
  ArticleItem(
    id: 'a4',
    title: 'Mengenal Risiko Obesitas dan Pencegahannya',
    description: 'Obesitas berkaitan dengan berbagai risiko kesehatan. Pendekatan yang aman meliputi pola makan seimbang, aktivitas fisik, dan konsultasi profesional bila diperlukan.',
    image: 'assets/images/articles/obesitas1.jpg',
    category: 'Obesitas',
  ),
  ArticleItem(
    id: 'a5',
    title: 'Pentingnya Aktivitas Fisik untuk Kesehatan',
    description: 'Aktivitas fisik membantu menjaga kebugaran, komposisi tubuh, kualitas tidur, dan kesehatan secara keseluruhan.',
    image: 'assets/images/articles/normal2.jpg',
    category: 'Normal',
  ),
];

String foodSuggestion(String category) {
  switch (category) {
    case 'Kurus':
      return 'Tambahkan sumber protein, karbohidrat kompleks, lemak sehat, susu atau olahannya, serta camilan bergizi agar asupan energi meningkat secara bertahap.';
    case 'Normal':
      return 'Pertahankan pola makan seimbang berisi sayur, buah, protein, karbohidrat kompleks, dan lemak sehat dengan porsi yang sesuai kebutuhan.';
    case 'Kelebihan Berat Badan':
      return 'Utamakan sayur, buah utuh, protein tanpa lemak, biji-bijian utuh, serta kurangi makanan tinggi gula dan lemak jenuh.';
    case 'Obesitas':
      return 'Pilih makanan tinggi serat dan protein, atur porsi, batasi minuman manis dan makanan ultra-proses. Pertimbangkan konsultasi ahli gizi untuk rencana yang sesuai.';
    default:
      return 'Jaga pola makan seimbang dan cukup cairan.';
  }
}

String vitaminSuggestion(String category) {
  switch (category) {
    case 'Kurus':
      return 'Penuhi vitamin dan mineral dari makanan beragam. Suplemen sebaiknya digunakan bila memang diperlukan dan sesuai saran tenaga kesehatan.';
    case 'Normal':
      return 'Pertahankan asupan vitamin dari buah dan sayur beragam. Cukup tidur dan aktivitas fisik juga penting untuk menjaga kebugaran.';
    case 'Kelebihan Berat Badan':
      return 'Utamakan mikronutrien dari makanan utuh. Hindari mengandalkan suplemen penurun berat badan tanpa rekomendasi tenaga kesehatan.';
    case 'Obesitas':
      return 'Pastikan asupan vitamin dan mineral tetap cukup selama pengaturan kalori. Konsultasikan suplemen tertentu dengan tenaga kesehatan.';
    default:
      return 'Penuhi kebutuhan vitamin dari makanan yang bervariasi.';
  }
}

String categorySubtitle(String category) {
  switch (category) {
    case 'Kurus':
      return 'Berat kurang dari normal';
    case 'Normal':
      return 'Berat badan dalam kisaran sehat';
    case 'Kelebihan Berat Badan':
      return 'Sedikit di atas normal';
    case 'Obesitas':
      return 'Berat terlalu berlebih';
    default:
      return '-';
  }
}

const defaultAbout = AboutContent(
  title: aboutTitle,
  opening: aboutOpening,
  goal: aboutGoal,
  features: aboutFeatures,
  email: 'cekbmiku@gmail.com',
);
