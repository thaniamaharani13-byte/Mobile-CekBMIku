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
    LifestyleTip(title: 'Batasi Makanan Olahan', description: 'Kurangi makanan tinggi gula, garam, dan lemak jenuh dalam menu harian.', asset: 'assets/images/recommendations/food_03.jpg'),
    LifestyleTip(title: 'Cukupi Kebutuhan Air Putih', description: 'Minum minimal 8 gelas air putih sehari untuk menjaga hidrasi dan fungsi tubuh optimal.', asset: 'assets/images/recommendations/food_04.jpg'),
  ];

  static const activity = <LifestyleTip>[
    LifestyleTip(title: 'Jalan Kaki Secara Rutin', description: 'Mulai dengan 10–15 menit berjalan kaki. Tambah durasi bertahap sesuai kenyamanan tubuh.', asset: 'assets/images/recommendations/activity_01.jpg'),
    LifestyleTip(title: 'Bersepeda Santai', description: 'Pilih rute aman dan gunakan helm. Kayuh dengan kecepatan yang masih nyaman untuk berbicara.', asset: 'assets/images/recommendations/activity_02.jpg'),
    LifestyleTip(title: 'Berenang Sesuai Kemampuan', description: 'Coba berenang santai di kolam yang diawasi. Istirahat di sela putaran saat mulai lelah.', asset: 'assets/images/recommendations/activity_03.jpg'),
    LifestyleTip(title: 'Latihan Kekuatan Ringan', description: 'Coba squat atau push-up di dinding 2 kali seminggu. Utamakan teknik dan mulai dari repetisi ringan.', asset: 'assets/images/recommendations/activity_04.jpg'),
    LifestyleTip(title: 'Peregangan Setelah Bergerak', description: 'Regangkan otot perlahan setelah aktivitas. Tahan dengan nyaman tanpa memantul atau memaksa.', asset: 'assets/images/recommendations/activity_05.jpg'),
    LifestyleTip(title: 'Pilih Tangga Jika Nyaman', description: 'Gunakan tangga untuk 1–2 lantai bila memungkinkan. Pegang pegangan dan sesuaikan ritme.', asset: 'assets/images/recommendations/activity_06.jpg'),
    LifestyleTip(title: 'Senam atau Menari di Rumah', description: 'Ikuti gerakan sederhana selama 10–20 menit. Pilih musik dan tempo yang membuatmu nyaman.', asset: 'assets/images/recommendations/activity_07.jpg'),
    LifestyleTip(title: 'Yoga untuk Gerak dan Relaksasi', description: 'Pilih gerakan yoga pemula dan bernapas teratur. Hindari posisi yang menimbulkan nyeri.', asset: 'assets/images/recommendations/activity_08.jpg'),
    LifestyleTip(title: 'Main Bulu Tangkis Santai', description: 'Ajak teman bermain dengan tempo ringan. Lakukan pemanasan dan ambil jeda minum seperlunya.', asset: 'assets/images/recommendations/activity_09.jpg'),
    LifestyleTip(title: 'Aktif Lewat Pekerjaan Rumah', description: 'Menyapu, mengepel, atau berkebun bisa menambah gerak harian. Bagi pekerjaan menjadi sesi singkat.', asset: 'assets/images/recommendations/activity_10.jpg'),
  ];

  static const lifestyle = <LifestyleTip>[
    LifestyleTip(title: 'Tidur Cukup dan Teratur', description: 'Usahakan tidur 7–9 jam untuk orang dewasa. Bangun dan tidur pada jam yang relatif sama.', asset: 'assets/images/recommendations/lifestyle_01.jpg'),
    LifestyleTip(title: 'Cukupi Kebutuhan Air Putih', description: 'Minum air secara berkala sepanjang hari. Sesuaikan kebutuhan dengan aktivitas, cuaca, dan kondisi tubuh.', asset: 'assets/images/recommendations/lifestyle_02.jpg'),
    LifestyleTip(title: 'Jaga Pola Makan Seimbang', description: 'Variasikan sayur, buah, protein, dan sumber karbohidrat. Nikmati porsi yang sesuai kebutuhanmu.', asset: 'assets/images/recommendations/lifestyle_03.jpg'),
    LifestyleTip(title: 'Kelola Stres dengan Jeda', description: 'Luangkan beberapa menit untuk bernapas perlahan, menulis jurnal, atau melakukan hobi yang disukai.', asset: 'assets/images/recommendations/lifestyle_04.jpg'),
    LifestyleTip(title: 'Batasi Layar Sebelum Tidur', description: 'Coba jeda dari gawai 30–60 menit sebelum tidur. Ganti dengan membaca atau rutinitas yang menenangkan.', asset: 'assets/images/recommendations/lifestyle_05.jpg'),
    LifestyleTip(title: 'Selingi Duduk dengan Bergerak', description: 'Berdiri dan berjalan sebentar setiap 30–60 menit saat bekerja atau belajar dalam posisi duduk.', asset: 'assets/images/recommendations/lifestyle_06.jpg'),
    LifestyleTip(title: 'Hindari Rokok dan Asapnya', description: 'Jaga rumah bebas asap rokok. Jika ingin berhenti merokok, cari dukungan dari orang dekat atau tenaga kesehatan.', asset: 'assets/images/recommendations/lifestyle_07.jpg'),
    LifestyleTip(title: 'Batasi Minuman Manis', description: 'Pilih air putih atau teh tanpa gula lebih sering. Periksa kandungan gula pada label minuman kemasan.', asset: 'assets/images/recommendations/lifestyle_08.jpg'),
    LifestyleTip(title: 'Luangkan Waktu Bersosialisasi', description: 'Sempatkan berbincang dengan keluarga atau teman. Pilih kegiatan bersama yang membuatmu merasa didukung.', asset: 'assets/images/recommendations/lifestyle_09.jpg'),
    LifestyleTip(title: 'Bangun Kebiasaan Bertahap', description: 'Pilih satu kebiasaan kecil yang realistis. Catat perkembangannya dan sesuaikan tanpa menyalahkan diri.', asset: 'assets/images/recommendations/lifestyle_10.jpg'),
  ];

}
