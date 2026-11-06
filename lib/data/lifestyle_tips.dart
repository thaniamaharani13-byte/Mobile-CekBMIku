// Rekomendasi pada UI yang disediakan untuk prototipe CekBMIku.
// Konten bersifat edukasi umum, bukan diagnosis/pengobatan personal.
class LifestyleTip {
  const LifestyleTip({required this.title, required this.description, required this.asset});

  final String title;
  final String description;
  final String asset;
}

class LifestyleTips {
  static const food = <LifestyleTip>[
LifestyleTip(title: 'Pilih Makanan Bergizi Seimbang', description: 'Konsumsi makanan dengan karbohidrat kompleks, protein, lemak sehat, vitamin, dan mineral.', asset: 'assets/images/recommendations/food_01.jpg'),
    LifestyleTip(title: 'Perbanyak Buah dan Sayur', description: 'Buah dan sayuran tinggi serat, vitamin, serta antioksidan yang baik untuk tubuh.', asset: 'assets/images/recommendations/food_02.jpg'),
  ];

  static const activity = <LifestyleTip>[
LifestyleTip(title: 'Jalan Kaki Secara Rutin', description: 'Mulai dengan 10–15 menit berjalan kaki. Tambah durasi bertahap sesuai kenyamanan tubuh.', asset: 'assets/images/recommendations/activity_01.jpg'),
    LifestyleTip(title: 'Bersepeda Santai', description: 'Pilih rute aman dan gunakan helm. Kayuh dengan kecepatan yang masih nyaman untuk berbicara.', asset: 'assets/images/recommendations/activity_02.jpg'),
  ];

  static const lifestyle = <LifestyleTip>[
LifestyleTip(title: 'Tidur Cukup dan Teratur', description: 'Usahakan tidur 7–9 jam untuk orang dewasa. Bangun dan tidur pada jam yang relatif sama.', asset: 'assets/images/recommendations/lifestyle_01.jpg'),
    LifestyleTip(title: 'Cukupi Kebutuhan Air Putih', description: 'Minum air secara berkala sepanjang hari. Sesuaikan kebutuhan dengan aktivitas, cuaca, dan kondisi tubuh.', asset: 'assets/images/recommendations/lifestyle_02.jpg'),
  ];
}
