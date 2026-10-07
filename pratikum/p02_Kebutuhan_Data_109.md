# Dokumen Kebutuhan Data - Wanda Store
### 1. Latar Belakang dan Aktivitas Organisasi
### 1.1 Latar Belakang
**Wanda Store** adalah platform toko daring (*e-commerce*) yang bergerak di bidang penjualan busana (*fashion*), aksesori, dan gaya hidup. Seiring berkembangnya jumlah pelanggan serta peningkatan volume transaksi harian, pengelolaan data operasional secara manual menimbulkan potensi masalah seperti ketidaksesuaian stok, keterlambatan pelacakan status pengiriman, serta kesulitan dalam analisis riwayat pembelian pelanggan.
Dokumen Kebutuhan Data ini disusun sebagai pedoman konseptual dan logikal dalam merancang struktur basis data yang solid, konsisten, aman, dan dapat mengakomodasi seluruh proses bisnis operasional Wanda Store secara terintegrasi.

### 1.2 Aktivitas Organisasi
Aktivitas utama organisasi Wanda Store meliputi:
1. **Pengelolaan Katalog Produk:** Registrasi produk baru, manajemen varian (ukuran dan warna), kategori, serta pembaruan persediaan stok.
2. **Manajemen Akun Pelanggan:** Pendaftaran akun, pemeliharaan profil, pengelolaan daftar alamat pengiriman, dan program keanggotaan.
3. **Pemrosesan Transaksi Penjualan:** Pengelolaan keranjang belanja, penerbitan tagihan (*invoice*), konfirmasi pembayaran, serta penanganan voucher diskon.
4. **Pemenuhan Pesanan & Logistik:** Pengemasan barang di gudang, penerbitan nomor resi pengiriman, serta pemantauan status pengiriman bekerja sama dengan jasa ekspedisi.
5. **Layanan & Retur Pelanggan:** Penanganan ulasan/rating produk dan pemrosesan pengajuan pengembalian barang (*return*).
6. **Pelaporan & Analisis Bisnis:** Penyusunan laporan omzet penjualan harian/bulanan, analisis produk terlaris (*best seller*), dan pemantauan kinerja stok.

### 2. Aktor dan Proses Bisnis
### 2.1 Daftar Aktor
1. **Pelanggan (Customer):** Mengakses katalog, membuat pesanan, melakukan pembayaran, serta memberikan ulasan.
2. **Admin Katalog:** Mengelola master data produk, varian, kategori, dan promosi/voucher.
3. **Staf Keuangan (Finance):** Verifikasi transaksi pembayaran dan penyusunan laporan keuangan.
4. **Staf Gudang & Logistik:** Memproses pengemasan barang, pembaruan stok fisik, dan input nomor resi pengiriman.
5. **Payment Gateway (Sistem Eksternal):** Memproses verifikasi pembayaran secara otomatis.
6. **Sistem Ekspedisi/Kurir (Sistem Eksternal):** Memperbarui status pelacakan pengiriman barang.
7. **Manajer Toko / Pemilik (Owner):** Memantau laporan kinerja operasional, analitik penjualan, dan strategi bisnis.

### 2.2 Tabel PB-xx: Daftar Proses Bisnis
| Kode | Nama Proses Bisnis | Deskripsi Proses | Aktor Terlibat |
| :--- | :--- | :--- | :--- |
| **PB-01** | Pengelolaan Produk & Varian | Menambah, mengubah, dan memperbarui data produk, harga, varian (ukuran/warna), serta stok. | Admin Katalog |
| **PB-02** | Registrasi & Manajemen Akun | Pendaftaran akun baru pelanggan, pemutakhiran profil, dan alamat pengiriman. | Pelanggan |
| **PB-03** | Transaksi Pemesanan (*Checkout*) | Pemilihan produk ke keranjang, penerapannya kode voucher, pemisahan opsi pengiriman, dan pemesanan. | Pelanggan |
| **PB-04** | Verifikasi Pembayaran | Menerbitkan kode pembayaran, menerima konfirmasi dari payment gateway, dan memperbarui status tagihan. | Pelanggan, Payment Gateway, Staf Keuangan |
| **PB-05** | Pengemasan & Pengiriman | Verifikasi pesanan terbayar, cetak label pengiriman, input nomor resi, dan penyerahan ke kurir. | Staf Gudang, Sistem Ekspedisi |
| **PB-06** | Penilaian & Ulasan Produk | Pelanggan memberikan rating bintang dan ulasan setelah transaksi berstatus selesai. | Pelanggan |
| **PB-07** | Pelaporan Penjualan & Analitik | Menyusun rekapitulasi transaksi harian/bulanan, omzet, serta statistik produk terlaris. | Manajer Toko, Staf Keuangan |

### 3. Dokumen Sumber yang Dianalisis
Analisis dilakukan terhadap dokumen fisik dan digital yang digunakan pada operasi Wanda Store:
1. **Formulir Profil Pelanggan (Digital):**
   * *Elemen Data:* ID Pelanggan, Nama Lengkap, Email, No. HP, Tanggal Lahir, Kata Sandi.
2. **Katalog Master Produk (Database/Excel):**
   * *Elemen Data:* Kode Produk (SKU), Nama Produk, Kategori, Varian (Ukuran/Warna), Harga Satuan, Stok Tersedia, Berat (gram).
3. **Faktur Penjualan / Digital Invoice:**
   * *Elemen Data:* No. Invoice, Tanggal Transaksi, ID Pelanggan, Daftar Item (SKU, Nama, Varian, Qty, Harga Satuan, Subtotal), Kode Voucher, Potongan Diskon, Biaya Kirim, Grand Total.
4. **Resi Pengiriman / Label Shipping:**
   * *Elemen Data:* No. Resi, No. Invoice, Nama Penerima, Alamat Lengkap, No. Telp Penerima, Jasa Ekspedisi, Paket Layanan, Total Berat.
5. **Bukti Pembayaran (Payment Receipt):**
   * *Elemen Data:* No. Transaksi PG, No. Invoice, Metode Pembayaran, Waktu Bayar, Jumlah Bayar, Status Pembayaran.

### 4. Entitas Kandidat dan Elemen Data
| Entitas Kandidat | Elemen Data Utama | Sumber Dokumen |
| :--- | :--- | :--- |
| **Pelanggan** | `id_pelanggan`, `nama_lengkap`, `email`, `kata_sandi`, `no_hp`, `tgl_registrasi`, `status_aktif` | Form Profil Pelanggan |
| **Alamat_Pengiriman** | `id_alamat`, `id_pelanggan`, `label_alamat`, `nama_penerima`, `no_hp_penerima`, `alamat_lengkap`, `kota`, `kode_pos`, `is_utama` | Form Alamat |
| **Kategori** | `id_kategori`, `nama_kategori`, `slug_kategori` | Katalog Produk |
| **Produk** | `id_produk`, `id_kategori`, `kode_sku`, `nama_produk`, `deskripsi`, `harga_satuan`, `berat_gram` | Katalog Produk |
| **Varian_Produk** | `id_varian`, `id_produk`, `ukuran`, `warna`, `stok_tersedia` | Katalog Produk |
| **Voucher** | `id_voucher`, `kode_voucher`, `potongan_harga`, `minimal_belanja`, `tgl_kadaluarsa` | Sistem Promosi |
| **Pesanan** | `id_pesanan`, `no_invoice`, `id_pelanggan`, `id_alamat`, `id_voucher`, `tgl_pesanan`, `total_barang`, `biaya_kirim`, `diskon`, `grand_total`, `status_pesanan` | Digital Invoice |
| **Detail_Pesanan** | `id_detail`, `id_pesanan`, `id_varian`, `jumlah_beli`, `harga_at_purchase`, `subtotal` | Digital Invoice |
| **Pembayaran** | `id_pembayaran`, `id_pesanan`, `no_transaksi_pg`, `metode_bayar`, `jumlah_bayar`, `waktu_bayar`, `status_bayar` | Payment Receipt |
| **Pengiriman** | `id_pengiriman`, `id_pesanan`, `kurir`, `layanan`, `no_resi`, `tgl_dikirim`, `tgl_diterima`, `status_pengiriman` | Resi Pengiriman |
| **Ulasan** | `id_ulasan`, `id_produk`, `id_pelanggan`, `id_pesanan`, `rating`, `komentar`, `tgl_ulasan` | Form Ulasan |

### 5. Aturan Bisnis
### Tabel AB-xx: Daftar Aturan Bisnis
| Kode | Aturan Bisnis |
| :--- | :--- |
| **AB-01** | Setiap pesanan diterbitkan dengan Nomor Invoice unik dan memuat minimal 1 item barang dengan batas maksimal **10 item per transaksi**. |
| **AB-02** | Setiap akun pelanggan terhubung dengan 1 alamat email unik (*unique constraint*) dan 1 nomor telepon utama. |
| **AB-03** | Pengurangan `stok_tersedia` pada `Varian_Produk` dilakukan saat pesanan dibuat (*checkout*). Transaksi akan ditolak jika `jumlah_beli` > `stok_tersedia`. |
| **AB-04** | Nilai `harga_at_purchase` pada detail pesanan harus mencatat harga riil saat transaksi dan tidak terpengaruh oleh perubahan harga master produk kelak. |
| **AB-05** | Kode voucher hanya dapat digunakan jika `total_barang` memenuhi batasan `minimal_belanja` dan durasi masa berlaku voucher masih aktif. |
| **AB-06** | Batas waktu pembayaran transaksi adalah **1x24 jam**. Jika melewati batas tersebut tanpa konfirmasi payment gateway, status pesanan otomatis berubah menjadi *Cancelled*. |
| **AB-07** | Input nomor resi pengiriman (`no_resi`) wajib dilakukan oleh staf gudang saat mengubah status pengiriman menjadi *Shipped*. |
| **AB-08** | Pelanggan hanya dapat memberikan rating dan ulasan pada produk yang pernah dibeli dan status pesanan telah bernilai *Completed*. |

### 6. Kebutuhan Informasi
### Tabel KI-xx: Daftar Kebutuhan Informasi
| Kode | Kebutuhan Informasi | Data yang Diperlukan | Pengguna / Aktor |
| :--- | :--- | :--- | :--- |
| **KI-01** | Laporan Omzet Penjualan Harian dan Bulanan | Pesanan, Pembayaran | Manajer Toko, Finance |
| **KI-02** | Daftar 10 Produk Varian Terlaris (*Best Seller*) | Detail_Pesanan, Varian_Produk, Produk | Admin Katalog, Owner |
| **KI-03** | Peringatan Restok Varian Barang (Stok < 5 Pcs) | Varian_Produk, Produk | Staf Gudang |
| **KI-04** | Riwayat Pesanan dan Tracking Pengiriman Pelanggan | Pesanan, Pengiriman, Detail_Pesanan | Pelanggan, Customer Service |
| **KI-05** | Laporan Transaksi Batal / Kadaluarsa Pembayaran | Pesanan, Pembayaran | Finance, Staf Gudang |
| **KI-06** | Rekapitulasi Tingkat Kepuasan Pelanggan (Rating & Ulasan) | Ulasan, Produk | Admin Katalog, Owner |

### 7. Matriks CRUD
| Proses Bisnis \ Entitas Data | Pelanggan | Produk & Varian | Pesanan & Detail | Pembayaran | Pengiriman | Ulasan |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01** Pengelolaan Produk & Varian | | C, R, U, D | | | | |
| **PB-02** Registrasi & Manajemen Akun | C, R, U | | | | | |
| **PB-03** Transaksi Pemesanan (*Checkout*) | R | R, U (Stok) | C, R | | | |
| **PB-04** Verifikasi Pembayaran | | | R, U | C, R, U | | |
| **PB-05** Pengemasan & Pengiriman | | R | R, U | R | C, R, U | |
| **PB-06** Penilaian & Ulasan Produk | | R | R | | | C, R, U |
| **PB-07** Pelaporan Penjualan & Analitik | R | R | R | R | R | R |

### 8. Kamus Data Awal
| Nama Atribut | Tipe Data | Kunci | Nullable | Deskripsi / Aturan Validasi | Penanggung Jawab |
| :--- | :--- | :---: | :---: | :--- | :--- |
| `id_pelanggan` | INT (Auto) | **PK** | No | ID unik identifier pelanggan | System Admin |
| `email` | VARCHAR(100) | - | No | Alamat email unik, format valid email | Pelanggan |
| `kode_sku` | VARCHAR(30) | - | No | Kode unik penanda produk (SKU) | Admin Katalog |
| `harga_satuan` | DECIMAL(12,2) | - | No | Harga katalog barang ($\ge 0$) | Admin Katalog |
| `stok_tersedia` | INT | - | No | Persediaan barang varian ($\ge 0$, AB-03) | Staf Gudang |
| `no_invoice` | VARCHAR(50) | - | No | Nomor invoice unik transaksi | System Automation |
| `harga_at_purchase`| DECIMAL(12,2) | - | No | Harga terkunci saat checkout (AB-04) | System Automation |
| `no_resi` | VARCHAR(50) | - | Yes | Nomor resi dari pihak ekspedisi | Staf Gudang |
| `rating` | TINYINT | - | Yes | Nilai rating bintang ($1 \le rating \le 5$) | Pelanggan |

### 9. Kebutuhan Non-Fungsional
1. **Perhitungan Parameter Personal ($P$):**
   * NIM: **xx.xx.xxxx79** $\rightarrow$ 2 digit terakhir $= 79$
   * $P = (79 \pmod 9) + 1 = 7 + 1 = \mathbf{8}$
   * Batas Maksimal Item/Transaksi $= 8 + 2 = \mathbf{10\text{ item}}$
   * Diskon Anggota / Voucher $= \mathbf{8\%}$
   * Perkiraan Volume Transaksi $= 40 + (5 \times 8) = \mathbf{80\text{ pesanan/hari}}$
2. **Kapasitas & Volume Data:**
   * Mampu menampung perkiraan 80–150 transaksi pemesanan harian.
   * Ukuran storage diproyeksikan bertambah \~15 GB per tahun.
3. **Retensi Data:**
   * Data transaksi aktif disimpan di basis data utama (*Production*) selama **3 tahun**.
   * Data di atas 3 tahun dipindahkan ke *Cold Storage / Data Warehouse* untuk keperluan audit operasional dan keuangan.
4. **Keamanan & Privasi Data:**
   * Kata sandi pelanggan wajib dienkripsi menggunakan *hashing algorithm* ($Argon2$ / $Bcrypt$).
   * Data privasi seperti nomor telepon dan detail alamat dilindungi sesuai ketentuan UU Protection Data Pribadi (UU PDP).

### 10. Isu Kualitas Data yang Diantisipasi
| No | Potensi Isu Kualitas Data | Dampak Bisnis | Tindakan Pencegahan / Mitigasi |
| :---: | :--- | :--- | :--- |
| **1** | **Inkonsistensi Harga Historis** | Laporan keuangan berubah jika harga master produk dinaikkan di kemudian hari. | Menyimpan atribut `harga_at_purchase` secara permanen pada tabel `Detail_Pesanan` (AB-04). |
| **2** | ***Overselling* / Stok Minus** | Dua pelanggan membeli barang varian terakhir di waktu yang persis bersamaan. | Mengimplementasikan teknik *Database Locking* (Optimistic/Pessimistic) saat pemrosesan *checkout*. |
| **3** | **Alamat Pengiriman Tidak Lengkap** | Paket retur atau gagal dikirim oleh kurir karena kekurangan data wilayah. | Validasi form alamat tingkat frontend dan integrasi API autokomplit kota & kode pos. |
| **4** | **Duplikasi Pendaftaran Akun** | Pengguna mendaftar ulang dengan kredensial serupa. | Penerapan *Unique Constraint* pada kolom `email` dan verifikasi OTP pada nomor HP. |