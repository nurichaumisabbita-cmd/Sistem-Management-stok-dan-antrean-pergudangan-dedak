abstract class ProdukDedak {
  // Encapsulation: Menggunakan '_' agar variabel bersifat private
  final String _jenis; 
  double beratKg;
  double hargaPerKg;

  // Konstruktor Utama Parent Class
  ProdukDedak(this._jenis, this.beratKg, this.hargaPerKg);

  // Getter: Pintu akses khusus untuk membaca nilai '_jenis' dari luar class
  String get jenis => _jenis;

  // Polymorphism: Cetakan awal method yang implementasinya akan berbeda di subclass
  double hitungTotalHarga();
}