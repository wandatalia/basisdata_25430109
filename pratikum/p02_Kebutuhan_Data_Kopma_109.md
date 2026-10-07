# Dokumen Kebutuhan Data - Kopma 

### 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa (Kopma)  mengelola penjualan kebutuhan harian, *merchandise* kampus, dan layanan toko kelontong mahasiswa. Permasalahan utama yang sering terjadi meliputi selisih pencatatan stok akibat barang rusak/kadaluarsa, keterlambatan pembaruan data dari pemasok, serta perhitungan poin voucher yang masih dilakukan secara manual. Dokumen kebutuhan data ini disusun sebagai acuan utama merancang struktur basis data yang andal dan konsisten.

### 2. Aktor dan Proses Bisnis
### Tabel PB-xx: Daftar Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| **PB-01** | Registrasi & Aktivasi Anggota | Kasir / Admin | Mahasiswa mendaftar via sistem |
| **PB-02** | Memproses Penjualan Ritel | Kasir | Pelanggan melakukan pembayaran |
| **PB-03** | Pencatatan Restok Barang | Petugas Gudang | Penerimaan pasokan dari *supplier* |
| **PB-04** | Pengajuan *Purchase Order* (PO) | Petugas Gudang | Stok mencapai *reorder point* |
| **PB-05** | Pelaporan Rekapitulasi Keuangan | Ketua Koperasi | Penutupan buku bulanan |
| **PB-06** | Penyesuaian Stok (*Stock Opname*) | Petugas Gudang | Penemuan barang rusak/hilang |

### 3. Dokumen Sumber yang Dianalisis
Dokumen sumber utama yang dianalisis meliputi **Struk Transaksi Digital Kopma** dan **Berita Acara *Stock Opname***:
* **Identitas Transaksi:** Kode Struk (`no_struk`), Tanggal, Jam Transaksi.
* **Informasi Pelanggan:** ID Anggota, Nama Anggota, Status Keanggotaan.
* **Detail Rincian Barang:** Kode Barcode, Nama Produk, Qty Terjual, Harga Satuan Transaksi.
* **Kalkulasi & Pembayaran:** Total Belanja, Potongan Voucher/Diskon, Poin Diperoleh, Jenis Pembayaran (Tunai / QRIS).

## 4. Entitas Kandidat dan Elemen Data
| Entitas Kandidat | Elemen Data Utama | Sumber |
| :--- | :--- | :--- |
| **Anggota** | `id_anggota`, `nim_anggota`, `nama_lengkap`, `program_studi`, `no_whatsapp`, `status_akun`, `saldo_poin` | Form Registrasi |
| **Barang** | `kode_barcode`, `nama_produk`, `kategori_produk`, `harga_jual`, `stok_tersedia`, `stok_minimal` | Katalog Barang |
| **Penjualan** | `no_struk`, `waktu_transaksi`, `id_kasir`, `id_anggota`, `metode_bayar`, `total_akhir` | Struk Transaksi |
| **Detail Penjualan** | `no_struk`, `kode_barcode`, `jumlah_beli`, `harga_realtime` | Struk Transaksi |
| 