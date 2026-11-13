/// Estimasi berat badan dengan rumus Broca berdasarkan pilihan jenis kelamin.
/// L = Pria (dikurangi 10%), P = Wanita (dikurangi 15%).
/// Bukan ukuran kesehatan atau berat badan ideal individual secara klinis.
class BrocaCalculator {
  const BrocaCalculator._();

  static int reductionPercent(String gender) => gender == 'L' ? 10 : 15;

  static String genderLabel(String gender) => gender == 'L' ? 'Pria' : 'Wanita';

  /// null jika tinggi <= 100 cm atau jenis kelamin tidak diketahui.
  static double? estimate({required double heightCm, required String gender}) {
    if (!heightCm.isFinite || heightCm <= 100 ||
        (gender != 'L' && gender != 'P')) {
      return null;
    }
    final base = heightCm - 100;
    final reduction = gender == 'L' ? 0.10 : 0.15;
    return base - (reduction * base);
  }
}
