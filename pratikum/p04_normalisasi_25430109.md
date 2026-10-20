# Normalisasi dan Skema Relasional - Wanda Store (Milestone Proyek 4)

**Nama:** Wanda Talia    
**NIM:** 25430109    
**Kelas:** D

### 1. Dokumen Sumber (titik awal UNF)

Saya memakai **Faktur Penjualan / Digital Invoice** (dokumen sumber no. 3 di Modul 2) karena satu faktur berisi banyak item, jadi ada grup berulang yang perlu dipecah. Data pelanggan, alamat, voucher, produk, dan kategori yang tampil di faktur ikut saya masukkan supaya semua anomali kelihatan. Atribut master lain (deskripsi, harga katalog, berat, stok) saya tambahkan dari Katalog Produk saat menyusun skema akhir.

### 2. UNF

```
INVOICE_UNF (no_invoice, tgl_pesanan, status_pesanan,
             id_pelanggan, nama_lengkap, email,
             id_alamat, nama_penerima, alamat_lengkap, kota, kode_pos,
             kode_voucher, potongan_harga, minimal_belanja, tgl_kadaluarsa,
             biaya_kirim,
             { id_varian, ukuran, warna, kode_sku, nama_produk,
               id_kategori, nama_kategori,
               jumlah_beli, harga_at_purchase, subtotal },
             total_barang, diskon, grand_total)
```

### 3. Bentuk 1NF

Grup berulang saya pecah menjadi satu baris per varian per invoice, sehingga kunci primernya komposit: **(no_invoice, id_varian)**.

```
INVOICE_1NF (no_invoice, id_varian, tgl_pesanan, status_pesanan,
             id_pelanggan, nama_lengkap, email,
             id_alamat, nama_penerima, alamat_lengkap, kota, kode_pos,
             kode_voucher, potongan_harga, minimal_belanja, tgl_kadaluarsa,
             biaya_kirim, ukuran, warna, kode_sku, nama_produk,
             id_kategori, nama_kategori,
             jumlah_beli, harga_at_purchase, subtotal,
             total_barang, diskon, grand_total)
PK = (no_invoice, id_varian)
```

### 4. Dependensi Fungsional dan Aturan Bisnis yang Mendasari

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_invoice -> tgl_pesanan, status_pesanan, id_alamat, kode_voucher, biaya_kirim, diskon | AB-01 (invoice unik); AB-05 (voucher per pesanan); AB-06 (status pesanan) |
| FD2 | id_pelanggan -> nama_lengkap, email | AB-02 (satu akun, satu email) |
| FD3 | id_alamat -> id_pelanggan, nama_penerima, alamat_lengkap, kota, kode_pos | entitas Alamat_Pengiriman: satu alamat milik satu akun pelanggan |
| FD4 | kode_voucher -> potongan_harga, minimal_belanja, tgl_kadaluarsa | AB-05 (syarat dan masa berlaku voucher) |
| FD5 | id_varian -> id_produk, ukuran, warna | entitas Varian_Produk: satu varian milik satu produk |
| FD6 | id_produk -> kode_sku, nama_produk, id_kategori | entitas Produk (satu SKU satu produk) |
| FD7 | id_kategori -> nama_kategori | entitas Kategori |
| FD8 | (no_invoice, id_varian) -> jumlah_beli, harga_at_purchase | AB-04 (harga terkunci per baris detail) |
| FD9 | jumlah_beli, harga_at_purchase -> subtotal | turunan (hitungan) |
| FD10 | seluruh subtotal pada satu invoice -> total_barang; total_barang, diskon, biaya_kirim -> grand_total | turunan (hitungan) |

**FD yang ditolak:**

- `id_varian -> harga_at_purchase`. Bertentangan dengan AB-04: harga pada pesanan tidak terpengaruh perubahan harga master produk.
- `id_produk -> harga_at_purchase`. Alasannya sama.

### 5. Menuju 2NF

Kunci tabelnya komposit (no_invoice, id_varian), jadi saya cari atribut yang cukup ditentukan oleh salah satu bagian kunci:

- Cukup ditentukan **no_invoice**: FD1 beserta atribut pelanggan, alamat, dan voucher di bawahnya. Saya pisah menjadi PESANAN.
- Cukup ditentukan **id_varian**: FD5, FD6, FD7 (ukuran, warna, produk, kategori). Saya pisah menjadi VARIAN.
- Butuh **seluruh kunci**: FD8 (jumlah dan harga saat transaksi). Tetap di DETAIL_PESANAN.

```
PESANAN (no_invoice, tgl_pesanan, status_pesanan,
         id_pelanggan, nama_lengkap, email,
         id_alamat, nama_penerima, alamat_lengkap, kota, kode_pos,
         kode_voucher, potongan_harga, minimal_belanja, tgl_kadaluarsa,
         biaya_kirim, diskon)
VARIAN (id_varian, ukuran, warna, id_produk, kode_sku, nama_produk,
        id_kategori, nama_kategori)
DETAIL_PESANAN (no_invoice, id_varian, jumlah_beli, harga_at_purchase)
```

### 6. Menuju 3NF

Rantai A → B → C yang saya temukan:

| Rantai | Penyelesaian |
|---|---|
| no_invoice -> id_pelanggan -> nama_lengkap, email (FD1 + FD2) | relasi PELANGGAN |
| no_invoice -> id_alamat -> nama_penerima, alamat_lengkap, kota, kode_pos (FD1 + FD3) | relasi ALAMAT_PENGIRIMAN |
| no_invoice -> kode_voucher -> potongan_harga, minimal_belanja, tgl_kadaluarsa (FD1 + FD4) | relasi VOUCHER |
| id_varian -> id_produk -> kode_sku, nama_produk (FD5 + FD6) | relasi PRODUK |
| id_produk -> id_kategori -> nama_kategori (FD6 + FD7) | relasi KATEGORI |
| **no_invoice -> id_alamat -> id_pelanggan** (FD1 + FD3) | **hapus id_pelanggan dari PESANAN** |

**Rantai terakhir paling menarik.** Setiap alamat milik satu pelanggan (FD3), jadi pelanggan yang memesan sudah bisa diketahui dari `id_alamat`. Kalau `id_pelanggan` juga disimpan di PESANAN, ia bergantung secara transitif. Maka saya hapus dari PESANAN, dan riwayat pesanan pelanggan (KI-04) dicari lewat `pesanan -> alamat_pengiriman -> pelanggan`. *(Kalau aturan bisnis ternyata membolehkan memesan ke alamat milik orang lain, FD3 perlu diubah dan `id_pelanggan` boleh dipertahankan di PESANAN.)*

**Hasil 3NF:**

```
PELANGGAN (id_pelanggan, nama_lengkap, email, kata_sandi, no_hp, tgl_registrasi, status_aktif)
ALAMAT_PENGIRIMAN (id_alamat, id_pelanggan*, label_alamat, nama_penerima, no_hp_penerima,
                   alamat_lengkap, kota, kode_pos, is_utama)
KATEGORI (id_kategori, nama_kategori, slug_kategori)
PRODUK (id_produk, id_kategori*, kode_sku, nama_produk, deskripsi, harga_satuan, berat_gram)
VARIAN_PRODUK (id_varian, id_produk*, ukuran, warna, stok_tersedia)
VOUCHER (id_voucher, kode_voucher, potongan_harga, minimal_belanja, tgl_kadaluarsa)
PESANAN (id_pesanan, no_invoice, id_alamat*, id_voucher* (boleh NULL), tgl_pesanan,
         biaya_kirim, diskon, status_pesanan)
DETAIL_PESANAN (id_detail, id_pesanan*, id_varian*, jumlah_beli, harga_at_purchase)
-- * = kunci tamu
```

`PEMBAYARAN`, `PENGIRIMAN`, dan `ULASAN` berasal dari dokumen sumber lain (Payment Receipt, Resi Pengiriman, Form Ulasan) dan diperiksa di bagian 8.

### 7. Keputusan Nilai Turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| subtotal (per detail) | **Tidak disimpan** | = jumlah_beli x harga_at_purchase; bisa tidak cocok bila jumlah atau harga dikoreksi |
| total_barang | **Tidak disimpan** | = jumlah seluruh subtotal pada invoice |
| grand_total | **Tidak disimpan** | = total_barang - diskon + biaya_kirim |
| diskon | **Disimpan** (snapshot) | potongan voucher dapat diubah Admin Katalog atau voucher dapat kedaluwarsa kelak; nilai potongan yang benar-benar diberikan saat checkout harus tetap, sama seperti prinsip harga pada AB-04 |
| biaya_kirim | **Disimpan** | tarif dari ekspedisi saat pesanan dibuat; bukan hasil hitungan dari data lain |
| jumlah_bayar (pembayaran) | **Disimpan** | uang yang benar-benar diterima via payment gateway |
| stok_tersedia | **Disimpan** (dijaga AB-03) | keadaan stok operasional yang diubah saat checkout; bukan salinan dari tabel lain |

Untuk laporan omzet (KI-01), `grand_total` dihitung lewat kueri atau *view*, tidak disimpan di tabel operasional.

### 8. Pemeriksaan BCNF (setiap tabel)

| Tabel | Penentu yang ada | Kunci kandidat? | Hasil |
|---|---|---|---|
| pelanggan | id_pelanggan, email (AB-02) | Ya, keduanya | BCNF |
| alamat_pengiriman | id_alamat | Ya | BCNF |
| kategori | id_kategori, nama_kategori, slug_kategori | Ya (nama dan slug dibuat unik pada ERD) | BCNF |
| produk | id_produk, kode_sku | Ya, keduanya | BCNF |
| varian_produk | id_varian, (id_produk, ukuran, warna) | Ya (kombinasi ukuran-warna unik per produk, asumsi katalog) | BCNF |
| voucher | id_voucher, kode_voucher | Ya, keduanya | BCNF |
| pesanan | id_pesanan, no_invoice (AB-01) | Ya, keduanya | BCNF |
| detail_pesanan | id_detail, (id_pesanan, id_varian) | Ya | BCNF |
| pembayaran | id_pembayaran, no_transaksi_pg | Ya (nomor transaksi gateway unik, asumsi) | BCNF |
| pengiriman | id_pengiriman, id_pesanan (satu pengiriman per pesanan) | Ya | BCNF |
| ulasan | id_ulasan (setelah id_pelanggan dihapus, lihat di bawah) | Ya | BCNF |

**Pelanggaran pada ULASAN yang saya perbaiki.** ERD lama menyimpan `id_produk`, `id_pelanggan`, dan `id_pesanan` sekaligus. Menurut AB-08, yang boleh mengulas adalah pembeli dari pesanan yang selesai, jadi `id_pesanan` sudah menentukan `id_pelanggan`. Masalahnya, `id_pesanan` bukan kunci kandidat karena satu pesanan bisa punya beberapa ulasan (satu per produk). Tabel ini melanggar BCNF. Perbaikannya: `id_pelanggan` dihapus dari ULASAN dan pelanggan dicari lewat `pesanan -> alamat_pengiriman -> pelanggan`.

```
ULASAN (id_ulasan, id_pesanan*, id_produk*, rating, komentar, tgl_ulasan)
PEMBAYARAN (id_pembayaran, id_pesanan*, no_transaksi_pg, metode_bayar, jumlah_bayar, waktu_bayar, status_bayar)
PENGIRIMAN (id_pengiriman, id_pesanan*, kurir, layanan, no_resi, tgl_dikirim, tgl_diterima, status_pengiriman)
```

Kunci pengganti `id_*` tidak otomatis membuat tabel normal, jadi pemeriksaan di atas saya lakukan dengan kunci alami (`email`, `kode_sku`, `no_invoice`, `kode_voucher`).

### 9. Skema Akhir 3NF (acuan DDL Pertemuan 5)

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| pelanggan | id_pelanggan | email | - |
| alamat_pengiriman | id_alamat | - | id_pelanggan |
| kategori | id_kategori | nama_kategori, slug_kategori | - |
| produk | id_produk | kode_sku | id_kategori |
| varian_produk | id_varian | (id_produk, ukuran, warna) | id_produk |
| voucher | id_voucher | kode_voucher | - |
| pesanan | id_pesanan | no_invoice | id_alamat, id_voucher (boleh NULL) |
| detail_pesanan | id_detail | (id_pesanan, id_varian) | id_pesanan, id_varian |
| pembayaran | id_pembayaran | no_transaksi_pg | id_pesanan |
| pengiriman | id_pengiriman | id_pesanan, no_resi (boleh NULL, AB-07) | id_pesanan |
| ulasan | id_ulasan | - | id_pesanan, id_produk |

Aturan bisnis yang nanti harus menjadi constraint di Pertemuan 5: AB-01 (UNIQUE `no_invoice`; maksimal item per invoice lewat trigger/aplikasi), AB-02 (UNIQUE `email`), AB-03 (CHECK `stok_tersedia >= 0`), AB-04 (kolom `harga_at_purchase` NOT NULL), AB-05 (UNIQUE `kode_voucher`, syarat minimal belanja dan masa berlaku divalidasi saat checkout), AB-07 (`no_resi` wajib saat status Shipped), AB-08 (validasi status pesanan Completed).

### 10. Perubahan ERD Proyek (dari `p03_erd_toko_daring.png`)

| No | Perubahan | Alasan |
|---|---|---|
| 1 | Tabel **alamat_pengiriman** ditambahkan; kolom `alamat_pelanggan` dihapus dari pelanggan; pesanan mendapat FK `id_alamat` | pelanggan boleh memiliki banyak alamat; satu kolom teks melanggar atomisitas dan tidak mendukung `is_utama` |
| 2 | Tabel **varian_produk** ditambahkan; `stok_produk` pindah menjadi `varian_produk.stok_tersedia`; `detail_pesanan.id_produk` berganti menjadi `id_varian` | dokumen Modul 2 mengelola varian ukuran/warna dan stok per varian (AB-03) |
| 3 | Tabel **voucher** ditambahkan; pesanan mendapat FK `id_voucher` (boleh NULL) dan kolom `diskon` | AB-05; voucher punya atribut sendiri (FD4) |
| 4 | **pesanan**: hapus `total_harga_pesanan` (turunan); hapus `id_pelanggan` (transitif lewat alamat); tambah `biaya_kirim`, `diskon` | bagian 6 dan 7 |
| 5 | **detail_pesanan**: hapus `subtotal` (turunan); `harga_satuan` diganti nama menjadi `harga_at_purchase` | bagian 7; AB-04 |
| 6 | **pengiriman**: `biaya_ongkir` dipindah ke `pesanan.biaya_kirim` | sesuai entitas Pesanan pada Modul 2 |
| 7 | **pembayaran**: tambah `no_transaksi_pg` (unik) | Payment Receipt (Modul 2) |
| 8 | Tabel **ulasan** ditambahkan tanpa `id_pelanggan` | AB-08; perbaikan BCNF (bagian 8) |
| 9 | Entitas **wishlist** pada ERD tidak ada di dokumen Modul 2 | belum punya proses bisnis, aturan bisnis, atau kebutuhan informasi; tambahkan ke dokumen Modul 2 bila dipertahankan, atau hapus dari ERD |


