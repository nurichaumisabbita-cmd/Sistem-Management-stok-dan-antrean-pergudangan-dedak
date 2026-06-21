// main.dart
import 'dart:io';
import 'dedak_komersial.dart';
import 'pembeli.dart';
import 'manajemen_gudang.dart';

void main() {
  ManajemenGudang gudangSelep = ManajemenGudang();

  print("\n[SISTEM] Menghubungkan ke database lokal...");
  gudangSelep.muatDataGudangDariCSV('gudang_dedak.csv');
  gudangSelep.muatDataPembeliDariCSV('antrean_pembeli.csv');
  print("[SISTEM] Data awal berhasil disinkronisasi.\n");

  bool programBerjalan = true; 

  print("=================================================");
  print("  SELAMAT DATANG DI SISTEM GUDANG SELEP DEDAK    ");
  print("=================================================");

  while (programBerjalan) {
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

        DedakKomersial karungBaru = DedakKomersial("Dedak Padi", berat, harga, kualitas);
        gudangSelep.pushDedak(karungBaru);

        gudangSelep.simpanDedakKeCSV('gudang_dedak.csv', karungBaru); 
        print("LOG: Data karung baru telah disimpan permanen ke CSV.");
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

        Pembeli pembeliBaru = Pembeli(nama, cariKualitas, jumlah);
        gudangSelep.enqueuePembeli(pembeliBaru);

        gudangSelep.simpanPembeliKeCSV('antrean_pembeli.csv', pembeliBaru);
        print("LOG: Data pembeli baru telah disimpan permanen ke CSV.");
        break;

      case '4':
        print("\n--- PELAYANAN LOKET (QUEUE DEQUEUE + TRANSAKSI) ---");
        Pembeli? pembeliSaatIni = gudangSelep.dequeuePembeli();
        
        if (pembeliSaatIni != null) {
          print("Memproses Transaksi untuk Pembeli: ${pembeliSaatIni.nama}");
          print("Mencari Stok Gudang Teratas untuk Kualitas: ${pembeliSaatIni.kualitasDicari}...");
          
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