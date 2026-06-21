// manajemen_gudang.dart
import 'dart:io';
import 'dedak_komersial.dart';
import 'pembeli.dart';

class ManajemenGudang {
  final List<DedakKomersial> _tumpukanGudang = []; 
  final List<Pembeli> _antreanLoket = [];          
  
  // BAGIAN A: LOGIKA OPERASI STACK (TUMPUKAN KARUNG)
  // Fungsi PUSH: Menaruh karung dedak baru di tumpukan paling atas
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

  // BAGIAN B: LOGIKA OPERASI QUEUE (ANTREAN PEMBELI LOKET)

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

  // BAGIAN C: MONITORING UTITAS (Fungsi Pembantu/Helper)
  void tampilkanStatusGudang() {
    print("\n=============================================");
    print("         STATUS MONITORING OPERASIONAL       ");
    print("=============================================");
    print(" Total Tumpukan Karung (Stack) : ${_tumpukanGudang.length} Karung");
    print(" Total Antrean Pembeli (Queue) : ${_antreanLoket.length} Orang");
    print("=============================================\n");
  }

  // BAGIAN D: ALGORITMA SEARCHING (PENCARIAN LINIER)
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
        print("-> Ketemu di Tumpukan Indeks ke-\$i: ${_tumpukanGudang[i].jenis} | Berat: ${_tumpukanGudang[i].beratKg} Kg | Harga Total: Rp ${_tumpukanGudang[i].hitungTotalHarga()}");
        ditemukan = true;
      }
    }

    if (!ditemukan) {
      print("-> Maaf, dedak dengan kualitas '\$kualitasDicari' tidak ditemukan di gudang.");
    }
    print("---------------------------------------------------\n");
  }

  // BAGIAN E: ALGORITMA SORTING (BUBBLE SORT MANUAL)
  void urutkanDedakBesarKeKecil() {
    if (_tumpukanGudang.length < 2) {
      print("LOG: [Sorting] Stok dedak kurang dari 2, tidak perlu diurutkan.");
      return;
    }

    int n = _tumpukanGudang.length;
    // Algoritma Bubble Sort
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        if (_tumpukanGudang[j].hargaPerKg > _tumpukanGudang[j + 1].hargaPerKg) {
          // Proses Penukaran (Swapping)
          DedakKomersial sementara = _tumpukanGudang[j];
          _tumpukanGudang[j] = _tumpukanGudang[j + 1];
          _tumpukanGudang[j + 1] = sementara;
        }
      }
    }
    print("LOG: [Sorting] Sukses! Tumpukan gudang telah diurutkan berdasarkan harga termurah -> termahal.");
  }

  // FUNGSI TAMBAHAN: MEMBACA DATA DARI FILE CSV
  
  // 1. Fungsi untuk membaca file CSV Stok Gudang (Stack)
  void muatDataGudangDariCSV(String namaFile) {
    final file = File(namaFile);
    
    // Validasi jika file tidak ditemukan
    if (!file.existsSync()) {
      print("LOG: [CSV] File $namaFile tidak ditemukan.");
      return;
    }

    try {
      final baris = file.readAsLinesSync();
      
      // Perulangan dimulai dari indeks 1 untuk melewati baris header (jenis,beratKg,hargaPerKg,kualitas)
      for (int i = 1; i < baris.length; i++) {
        if (baris[i].trim().isEmpty) continue; // Lewati jika ada baris kosong

        final kolom = baris[i].split(',');
        if (kolom.length == 4) {
          String jenis = kolom[0].trim();
          double berat = double.tryParse(kolom[1].trim()) ?? 0.0;
          double harga = double.tryParse(kolom[2].trim()) ?? 0.0;
          String kualitas = kolom[3].trim();

          // Memasukkan objek langsung ke dalam List _tumpukanGudang (Stack)
          _tumpukanGudang.add(DedakKomersial(jenis, berat, harga, kualitas));
        }
      }
      print("LOG: [CSV] Berhasil memuat data dari $namaFile ke tumpukan gudang.");
    } catch (e) {
      print("LOG: [CSV] Gagal membaca file gudang: $e");
    }
  }

  // 2. Fungsi untuk membaca file CSV Antrean Pembeli (Queue)
  void muatDataPembeliDariCSV(String namaFile) {
    final file = File(namaFile);
    
    if (!file.existsSync()) {
      print("LOG: [CSV] File $namaFile tidak ditemukan.");
      return;
    }

    try {
      final baris = file.readAsLinesSync();
      
      // Perulangan dimulai dari indeks 1 untuk melewati baris header (nama,kualitasDicari,jumlahKarung)
      for (int i = 1; i < baris.length; i++) {
        if (baris[i].trim().isEmpty) continue;

        final kolom = baris[i].split(',');
        if (kolom.length == 3) {
          String nama = kolom[0].trim();
          String kualitasDicari = kolom[1].trim();
          int jumlah = int.tryParse(kolom[2].trim()) ?? 1;

          // Memasukkan objek langsung ke dalam List _antreanLoket (Queue)
          _antreanLoket.add(Pembeli(nama, kualitasDicari, jumlah));
        }
      }
      print("LOG: [CSV] Berhasil memuat data dari $namaFile ke antrean loket.");
    } catch (e) {
      print("LOG: [CSV] Gagal membaca file pembeli: $e");
    }
  }

  // Fungsi untuk menambah baris baru ke CSV Gudang
  void simpanDedakKeCSV(String namaFile, DedakKomersial dedak) {
    final file = File(namaFile);
    // FileMode.append artinya data baru ditulis di baris paling bawah tanpa menghapus data lama
    file.writeAsStringSync(
      "${dedak.jenis},${dedak.beratKg},${dedak.hargaPerKg},${dedak.kualitas}\n",
      mode: FileMode.append,
    );
  }

  // Fungsi untuk menambah baris baru ke CSV Pembeli
  void simpanPembeliKeCSV(String namaFile, Pembeli pembeli) {
    final file = File(namaFile);
    file.writeAsStringSync(
      "${pembeli.nama},${pembeli.kualitasDicari},${pembeli.jumlahKarung}\n",
      mode: FileMode.append,
    );
  }
}