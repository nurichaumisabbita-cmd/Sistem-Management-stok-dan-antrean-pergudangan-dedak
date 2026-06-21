import 'dart:io';
// =========================================================================
// CLASS 1: ABSTRACT CLASS / INDUK CLASS (Memenuhi Syarat Konsep OOP)
// =========================================================================
abstract class ProdukDedak {
  // Encapsulation: Menggunakan '_' agar variabel bersifat private (aman)
  String _jenis; 
  double beratKg;
  double hargaPerKg;

  // Konstruktor Utama Parent Class
  ProdukDedak(this._jenis, this.beratKg, this.hargaPerKg);

  // Getter: Pintu akses khusus untuk membaca nilai '_jenis' dari luar class
  String get jenis => _jenis;

  // Polymorphism: Cetakan awal method yang implementasinya akan berbeda di subclass
  double hitungTotalHarga();
}

// =========================================================================
// CLASS 2: INHERITANCE / ANAK CLASS (Sudah Diperlengkap Lengkap Halus & Kasar)
// =========================================================================
class DedakKomersial extends ProdukDedak {
  String kualitas; // Berisi pilihan spesifik: "Halus" atau "Kasar"

  // Konstruktor Subclass: Memanggil 'super' untuk mengisi data ke kelas induk
  DedakKomersial(String jenis, double beratKg, double hargaPerKg, this.kualitas)
      : super(jenis, beratKg, hargaPerKg);

  // Polymorphism (Method Overriding): Menentukan rumus harga berdasarkan kualitas
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

// =========================================================================
// CLASS 3: STANDALONE CLASS / CLASS MANDIRI (Representasi Objek Nyata)
// =========================================================================
class Pembeli {
  String nama;
  String kualitasDicari; // "Halus" atau "Kasar"
  int jumlahKarung;

  // Konstruktor Utama Class Pembeli
  Pembeli(this.nama, this.kualitasDicari, this.jumlahKarung);
}

// =========================================================================
// CLASS 4: MESIN UTAMA MANAJEMEN STRUKTUR DATA (STACK & QUEUE)
// =========================================================================
class ManajemenGudang {
  // Wadah data internal (dibuat private agar strukturnya tidak diacak-acak luar class)
  final List<DedakKomersial> _tumpukanGudang = []; // Implementasi wadah STACK (LIFO)
  final List<Pembeli> _antreanLoket = [];          // Implementasi wadah QUEUE (FIFO)

  // -----------------------------------------------------------------------
  // BAGIAN A: LOGIKA OPERASI STACK (TUMPUKAN KARUNG)
  // -----------------------------------------------------------------------
  
  // Fungsi PUSH: Menaruh karung dedak baru di tumpukan paling atas (paling belakang di List)
  void pushDedak(DedakKomersial dedak) {
    _tumpukanGudang.add(dedak);
    print("LOG: [Stack-Push] Berhasil menumpuk 1 karung ${dedak.jenis} (${dedak.kualitas}) di gudang.");
  }

  // Fungsi POP: Mengambil karung dedak teratas (elemen terakhir di List)
  DedakKomersial? popDedak() {
    if (_tumpukanGudang.isEmpty) {
      print("LOG: [Stack-Pop] Gudang kosong! Tidak ada tumpukan dedak yang bisa diambil.");
      return null;
    }
    // .removeLast() otomatis mengambil dan menghapus data paling akhir (Sesuai konsep LIFO)
    return _tumpukanGudang.removeLast();
  }

  // -----------------------------------------------------------------------
  // BAGIAN B: LOGIKA OPERASI QUEUE (ANTREAN PEMBELI LOKET)
  // -----------------------------------------------------------------------

  // Fungsi ENQUEUE: Pembeli baru datang dan mendaftar di barisan paling belakang
  void enqueuePembeli(Pembeli pembeli) {
    _antreanLoket.add(pembeli);
    print("LOG: [Queue-Enqueue] Pembeli bernama '${pembeli.nama}' telah masuk ke dalam antrean.");
  }

  // Fungsi DEQUEUE: Memanggil dan melayani pembeli yang berada di urutan paling depan
  Pembeli? dequeuePembeli() {
    if (_antreanLoket.isEmpty) {
      print("LOG: [Queue-Dequeue] Antrean kosong! Tidak ada pembeli yang mengantre di loket.");
      return null;
    }
    // .removeAt(0) otomatis mengambil data nomor indeks 0/terdepan (Sesuai konsep FIFO)
    return _antreanLoket.removeAt(0);
  }

  // -----------------------------------------------------------------------
  // BAGIAN C: MONITORING UTITAS (Fungsi Pembantu/Helper)
  // -----------------------------------------------------------------------
  void tampilkanStatusGudang() {
    print("\n=============================================");
    print("         STATUS MONITORING OPERASIONAL       ");
    print("=============================================");
    print(" Total Tumpukan Karung (Stack) : ${_tumpukanGudang.length} Karung");
    print(" Total Antrean Pembeli (Queue) : ${_antreanLoket.length} Orang");
    print("=============================================\n");
  }

  // =========================================================================
  // BAGIAN D: ALGORITMA SEARCHING (PENCARIAN LINIER)
  // =========================================================================
  // Fungsi untuk mencari apakah ada dedak dengan kualitas tertentu di gudang
  void cariDedakBerdasarkanKualitas(String kualitasDicari) {
    if (_tumpukanGudang.isEmpty) {
      print("LOG: [Search] Gagal mencari, gudang masih kosong.");
      return;
    }

    print("\n--- HASIL PENCARIAN KUALITAS: ${kualitasDicari.toUpperCase()} ---");
    bool ditemukan = false;

    // Melakukan perulangan (looping) mengecek tumpukan satu per satu
    for (int i = 0; i < _tumpukanGudang.length; i++) {
      if (_tumpukanGudang[i].kualitas.toLowerCase() == kualitasDicari.toLowerCase()) {
        print("-> Ketemu di Tumpukan Indeks ke-$i: ${_tumpukanGudang[i].jenis} | Berat: ${_tumpukanGudang[i].beratKg} Kg | Harga Total: Rp ${_tumpukanGudang[i].hitungTotalHarga()}");
        ditemukan = true;
      }
    }

    if (!ditemukan) {
      print("-> Maaf, dedak dengan kualitas '$kualitasDicari' tidak ditemukan di gudang.");
    }
    print("---------------------------------------------------\n");
  }

  // =========================================================================
  // BAGIAN E: ALGORITMA SORTING (BUBBLE SORT MANUAL)
  // =========================================================================
  // Fungsi mengurutkan tumpukan dedak dari HARGA TERMURAH ke TERMAHAL
  void urutkanDedakBesarKeKecil() {
    if (_tumpukanGudang.length < 2) {
      print("LOG: [Sorting] Stok dedak kurang dari 2, tidak perlu diurutkan.");
      return;
    }

    int n = _tumpukanGudang.length;
    // Algoritma Bubble Sort: Membandingkan dua data bersebelahan lalu menukarnya
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        // Jika harga dedak di kiri lebih besar dari yang di kanan, kita tukar posisinya
        if (_tumpukanGudang[j].hargaPerKg > _tumpukanGudang[j + 1].hargaPerKg) {
          // Proses Penukaran (Swapping) menggunakan variabel penampung sementara
          DedakKomersial sementara = _tumpukanGudang[j];
          _tumpukanGudang[j] = _tumpukanGudang[j + 1];
          _tumpukanGudang[j + 1] = sementara;
        }
      }
    }
    print("LOG: [Sorting] Sukses! Tumpukan gudang telah diurutkan berdasarkan harga termurah -> termahal.");
  }
}

void main() {
  // Membuat satu objek utama dari mesin manajemen gudang kita
  ManajemenGudang gudangSelep = ManajemenGudang();
  bool programBerjalan = true;

  print("=================================================");
  print("  SELAMAT DATANG DI SISTEM GUDANG SELEP DEDAK    ");
  print("=================================================");

  while (programBerjalan) {
    // Tampilkan status monitoring setiap kali menu utama muncul
    gudangSelep.tampilkanStatusGudang();

    print("=== PILIHAN MENU OPERASIONAL ===");
    print("1. Push: Tambah Karung Dedak ke Tumpukan Gudang");
    print("2. Pop : Ambil Karung Dedak Teratas");
    print("3. Enqueue: Daftarkan Antrean Pembeli di Loket");
    print("4. Dequeue: Layani Pembeli Terdepan (Transaksi)");
    print("5. Searching: Cari Dedak Berdasarkan Kualitas");
    print("6. Sorting: Urutkan Tumpukan Gudang (Termurah -> Termahal)");
    print("7. Keluar Aplikasi");
    stdout.write("Pilih menu (1-7): ");
    
    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        print("\n--- INPUT TAMBAH KARUNG DEDAK (STACK PUSH) ---");
        stdout.write("Masukkan Berat (Kg): ");
        double berat = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;
        stdout.write("Masukkan Harga per Kg: ");
        double harga = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;
        stdout.write("Masukkan Kualitas (Halus/Kasar): ");
        String kualitas = stdin.readLineSync() ?? 'Kasar';

        // Membuat objek dedak baru berdasarkan input
        DedakKomersial karungBaru = DedakKomersial("Dedak Padi", berat, harga, kualitas);
        // Dimasukkan ke dalam Stack
        gudangSelep.pushDedak(karungBaru);
        break;

      case '2':
        print("\n--- AMBIL KARUNG TERATAS (STACK POP) ---");
        DedakKomersial? karungDiambil = gudangSelep.popDedak();
        if (karungDiambil != null) {
          print("SUKSES: Mengeluarkan 1 Karung ${karungDiambil.jenis}.");
          print("Detail -> Kualitas: ${karungDiambil.kualitas} | Berat: ${karungDiambil.beratKg} Kg | Total Nilai: Rp ${karungDiambil.hitungTotalHarga()}");
        }
        break;

      case '3':
        print("\n--- PENDAFTARAN ANTREAN PEMBELI (QUEUE ENQUEUE) ---");
        stdout.write("Masukkan Nama Pembeli: ");
        String nama = stdin.readLineSync() ?? 'Tanpa Nama';
        stdout.write("Kualitas yang Dicari (Halus/Kasar): ");
        String cariKualitas = stdin.readLineSync() ?? 'Kasar';
        stdout.write("Jumlah Karung yang Ingin Dibeli: ");
        int jumlah = int.tryParse(stdin.readLineSync() ?? '') ?? 1;

        // Membuat objek pembeli baru
        Pembeli pembeliBaru = Pembeli(nama, cariKualitas, jumlah);
        // Dimasukkan ke dalam Queue
        gudangSelep.enqueuePembeli(pembeliBaru);
        break;

      case '4':
        print("\n--- PELAYANAN LOKET (QUEUE DEQUEUE + TRANSAKSI) ---");
        // Panggil pembeli terdepan (FIFO)
        Pembeli? pembeliSaatIni = gudangSelep.dequeuePembeli();
        
        if (pembeliSaatIni != null) {
          print("Memproses Transaksi untuk Pembeli: ${pembeliSaatIni.nama}");
          print("Mencari Stok Gudang Teratas untuk Kualitas: ${pembeliSaatIni.kualitasDicari}...");
          
          // Ambil karung dedak teratas dari gudang (LIFO)
          DedakKomersial? karungStok = gudangSelep.popDedak();
          
          if (karungStok != null) {
            print("\n>>> NOTA TRANSAKSI ELEKTRONIK <<<");
            print("Pelanggan   : ${pembeliSaatIni.nama}");
            print("Barang      : ${karungStok.jenis} (${karungStok.kualitas})");
            print("Berat       : ${karungStok.beratKg} Kg");
            print("Total Bayar : Rp ${karungStok.hitungTotalHarga()}");
            print("---------------------------------");
            print("STATUS: Transaksi Selesai & Karung Diserahkan.");
          } else {
            print("PERINGATAN: Transaksi ditunda karena stok karung di gudang kosong!");
            // Masukkan kembali pembeli ke antrean terdepan jika stok kosong (opsional simulasi)
            gudangSelep.enqueuePembeli(pembeliSaatIni);
          }
        }
        break;

      case '5':
        print("\n--- MENU PENCARIAN STOK (SEARCHING) ---");
        stdout.write("Masukkan Kualitas Dedak yang Dicari (Halus/Kasar): ");
        String keyword = stdin.readLineSync() ?? '';
        gudangSelep.cariDedakBerdasarkanKualitas(keyword);
        break;

      case '6':
        print("\n--- MENU PENGURUTAN HARGA GUDANG (SORTING) ---");
        gudangSelep.urutkanDedakBesarKeKecil();
        break;

      case '7':
        print("\nKeluar dari sistem. Terima kasih, selamat bekerja kembali!");
        programBerjalan = false;
        break;

      default:
        print("\nPilihan menu tidak valid! Silakan ketik angka 1 sampai 7.");
    }
  }
}