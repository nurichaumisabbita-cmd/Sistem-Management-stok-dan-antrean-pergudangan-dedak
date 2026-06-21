import 'produk_dedak.dart';

class DedakKomersial extends ProdukDedak {
  String kualitas; 
  
  DedakKomersial(String jenis, double beratKg, double hargaPerKg, this.kualitas)
      : super(jenis, beratKg, hargaPerKg);

  @override
  double hitungTotalHarga() {
    if (kualitas.toLowerCase() == "halus") {
      // Dedak halus butuh proses filter ekstra, disimulasikan ada tambahan Rp 5.000
      return (beratKg * hargaPerKg) + 5000; 
    } else if (kualitas.toLowerCase() == "kasar") {
      // Dedak kasar dihitung normal sesuai tarif dasar gudang
      return beratKg * hargaPerKg;
    } else {
      // Proteksi jika terjadi kesalahan input teks kualitas di luar sistem
      return beratKg * hargaPerKg;
    }
  }
}