USE tokodaring_109;

-- ---------------------------------------------------------------------
-- Hapus ulang (urutan anak -> induk) agar skrip dapat dijalankan berulang
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS ulasan;
DROP TABLE IF EXISTS pengiriman;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_pesanan;
DROP TABLE IF EXISTS pesanan;
DROP TABLE IF EXISTS alamat_pengiriman;
DROP TABLE IF EXISTS varian_produk;
DROP TABLE IF EXISTS produk;
DROP TABLE IF EXISTS voucher;
DROP TABLE IF EXISTS kategori;
DROP TABLE IF EXISTS pelanggan;

-- ---------------------------------------------------------------------
-- Tabel master tanpa kunci tamu
-- ---------------------------------------------------------------------
CREATE TABLE pelanggan (
  id_pelanggan   INT          NOT NULL AUTO_INCREMENT,
  nama_lengkap   VARCHAR(100) NOT NULL,
  email          VARCHAR(100) NOT NULL,                       -- DATA PRIBADI
  kata_sandi     VARCHAR(255) NOT NULL,                       -- hash Argon2/Bcrypt, bukan teks asli
  no_hp          VARCHAR(15)  NOT NULL,                       -- DATA PRIBADI; AB-02: 1 nomor telepon utama
  tgl_registrasi DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_aktif   TINYINT(1)   NOT NULL DEFAULT 1,
  CONSTRAINT pk_pelanggan PRIMARY KEY (id_pelanggan),
  CONSTRAINT uq_pelanggan_email UNIQUE KEY (email),           -- AB-02
  CONSTRAINT ck_pelanggan_status CHECK (status_aktif IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE kategori (
  id_kategori   INT         NOT NULL AUTO_INCREMENT,
  nama_kategori VARCHAR(60) NOT NULL,
  slug_kategori VARCHAR(80) NOT NULL,
  CONSTRAINT pk_kategori PRIMARY KEY (id_kategori),
  CONSTRAINT uq_kategori_nama UNIQUE KEY (nama_kategori),
  CONSTRAINT uq_kategori_slug UNIQUE KEY (slug_kategori)
) ENGINE=InnoDB;

CREATE TABLE voucher (
  id_voucher      INT           NOT NULL AUTO_INCREMENT,
  kode_voucher    VARCHAR(30)   NOT NULL,
  potongan_harga  DECIMAL(12,2) NOT NULL,                     -- nilai potongan (samakan satuannya dgn dokumen Modul 2)
  minimal_belanja DECIMAL(12,2) NOT NULL DEFAULT 0,           -- AB-05
  tgl_kadaluarsa  DATE          NOT NULL,                     -- AB-05
  CONSTRAINT pk_voucher PRIMARY KEY (id_voucher),
  CONSTRAINT uq_voucher_kode UNIQUE KEY (kode_voucher),
  CONSTRAINT ck_voucher_potongan CHECK (potongan_harga >= 0),
  CONSTRAINT ck_voucher_minimal  CHECK (minimal_belanja >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Katalog
-- ---------------------------------------------------------------------
CREATE TABLE produk (
  id_produk    INT           NOT NULL AUTO_INCREMENT,
  id_kategori  INT           NOT NULL,
  kode_sku     VARCHAR(30)   NOT NULL,
  nama_produk  VARCHAR(150)  NOT NULL,
  deskripsi    TEXT          NULL,
  harga_satuan DECIMAL(12,2) NOT NULL,                        -- harga katalog saat ini (BUKAN harga di pesanan, AB-04)
  berat_gram   INT           NOT NULL,
  CONSTRAINT pk_produk PRIMARY KEY (id_produk),
  CONSTRAINT uq_produk_sku UNIQUE KEY (kode_sku),
  CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori) REFERENCES kategori (id_kategori),
  CONSTRAINT ck_produk_harga CHECK (harga_satuan >= 0),
  CONSTRAINT ck_produk_berat CHECK (berat_gram >= 0)
) ENGINE=InnoDB;

CREATE TABLE varian_produk (
  id_varian     INT         NOT NULL AUTO_INCREMENT,
  id_produk     INT         NOT NULL,
  ukuran        VARCHAR(10) NOT NULL,                         -- aksesori tanpa ukuran: isi 'ALL'
  warna         VARCHAR(30) NOT NULL,
  stok_tersedia INT         NOT NULL DEFAULT 0,
  CONSTRAINT pk_varian_produk PRIMARY KEY (id_varian),
  CONSTRAINT uq_varian_produk_kombinasi UNIQUE KEY (id_produk, ukuran, warna),
  CONSTRAINT fk_varian_produk_produk FOREIGN KEY (id_produk) REFERENCES produk (id_produk),
  CONSTRAINT ck_varian_produk_stok CHECK (stok_tersedia >= 0)  -- AB-03 (stok tidak boleh minus)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Pelanggan dan pesanan
-- ---------------------------------------------------------------------
CREATE TABLE alamat_pengiriman (
  id_alamat      INT          NOT NULL AUTO_INCREMENT,
  id_pelanggan   INT          NOT NULL,
  label_alamat   VARCHAR(30)  NOT NULL,                       -- mis. Rumah, Kantor
  nama_penerima  VARCHAR(100) NOT NULL,                       -- DATA PRIBADI
  no_hp_penerima VARCHAR(15)  NOT NULL,                       -- DATA PRIBADI
  alamat_lengkap VARCHAR(255) NOT NULL,                       -- DATA PRIBADI
  kota           VARCHAR(60)  NOT NULL,
  kode_pos       CHAR(5)      NOT NULL,                       -- isu kualitas data no. 3: alamat lengkap
  is_utama       TINYINT(1)   NOT NULL DEFAULT 0,
  CONSTRAINT pk_alamat_pengiriman PRIMARY KEY (id_alamat),
  CONSTRAINT fk_alamat_pengiriman_pelanggan FOREIGN KEY (id_pelanggan) REFERENCES pelanggan (id_pelanggan),
  CONSTRAINT ck_alamat_pengiriman_utama CHECK (is_utama IN (0,1))
) ENGINE=InnoDB;

CREATE TABLE pesanan (
  id_pesanan     INT           NOT NULL AUTO_INCREMENT,
  no_invoice     VARCHAR(50)   NOT NULL,
  id_alamat      INT           NOT NULL,                      -- pelanggan diketahui lewat alamat (Modul 4)
  id_voucher     INT           NULL,                          -- NULL = tanpa voucher
  tgl_pesanan    DATETIME      NOT NULL,
  biaya_kirim    DECIMAL(12,2) NOT NULL DEFAULT 0,
  diskon         DECIMAL(12,2) NOT NULL DEFAULT 0,            -- snapshot potongan saat checkout (Modul 4)
  status_pesanan ENUM('pending','dibayar','dikirim','selesai','dibatalkan') NOT NULL DEFAULT 'pending',
                                                              -- AB-06 Cancelled=dibatalkan, AB-08 Completed=selesai
  CONSTRAINT pk_pesanan PRIMARY KEY (id_pesanan),
  CONSTRAINT uq_pesanan_invoice UNIQUE KEY (no_invoice),      -- AB-01
  CONSTRAINT fk_pesanan_alamat_pengiriman FOREIGN KEY (id_alamat) REFERENCES alamat_pengiriman (id_alamat),
  CONSTRAINT fk_pesanan_voucher FOREIGN KEY (id_voucher) REFERENCES voucher (id_voucher),
  CONSTRAINT ck_pesanan_biaya_kirim CHECK (biaya_kirim >= 0),
  CONSTRAINT ck_pesanan_diskon CHECK (diskon >= 0)
) ENGINE=InnoDB;

CREATE TABLE detail_pesanan (
  id_detail         INT           NOT NULL AUTO_INCREMENT,
  id_pesanan        INT           NOT NULL,
  id_varian         INT           NOT NULL,
  jumlah_beli       SMALLINT      NOT NULL,
  harga_at_purchase DECIMAL(12,2) NOT NULL,                   -- AB-04: harga terkunci saat checkout
  CONSTRAINT pk_detail_pesanan PRIMARY KEY (id_detail),
  CONSTRAINT uq_detail_pesanan_varian UNIQUE KEY (id_pesanan, id_varian),  -- satu varian satu baris per pesanan
  CONSTRAINT fk_detail_pesanan_pesanan FOREIGN KEY (id_pesanan)
    REFERENCES pesanan (id_pesanan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_pesanan_varian_produk FOREIGN KEY (id_varian) REFERENCES varian_produk (id_varian),
  CONSTRAINT ck_detail_pesanan_jumlah CHECK (jumlah_beli > 0),   -- per baris; batas jumlah baris: lihat catatan AB-01
  CONSTRAINT ck_detail_pesanan_harga  CHECK (harga_at_purchase >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Pembayaran, pengiriman, ulasan
-- ---------------------------------------------------------------------
CREATE TABLE pembayaran (
  id_pembayaran   INT           NOT NULL AUTO_INCREMENT,
  id_pesanan      INT           NOT NULL,
  no_transaksi_pg VARCHAR(50)   NOT NULL,                     -- nomor transaksi payment gateway
  metode_bayar    ENUM('transfer_bank','e-wallet','cod','kartu_kredit') NOT NULL,
  jumlah_bayar    DECIMAL(12,2) NOT NULL,                     -- uang yang benar-benar diterima
  waktu_bayar     DATETIME      NULL,                         -- NULL selama status 'menunggu'
  status_bayar    ENUM('menunggu','berhasil','gagal') NOT NULL DEFAULT 'menunggu',
  CONSTRAINT pk_pembayaran PRIMARY KEY (id_pembayaran),
  CONSTRAINT uq_pembayaran_pg UNIQUE KEY (no_transaksi_pg),
  CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan),
  CONSTRAINT ck_pembayaran_jumlah CHECK (jumlah_bayar >= 0)
) ENGINE=InnoDB;

CREATE TABLE pengiriman (
  id_pengiriman     INT          NOT NULL AUTO_INCREMENT,
  id_pesanan        INT          NOT NULL,
  kurir             VARCHAR(50)  NOT NULL,
  layanan           VARCHAR(50)  NOT NULL,
  no_resi           VARCHAR(50)  NULL,                        -- AB-07: wajib saat status 'dikirim' (Shipped)
  tgl_dikirim       DATETIME     NULL,
  tgl_diterima      DATETIME     NULL,
  status_pengiriman ENUM('dikemas','dikirim','diterima') NOT NULL DEFAULT 'dikemas',
  CONSTRAINT pk_pengiriman PRIMARY KEY (id_pengiriman),
  CONSTRAINT uq_pengiriman_pesanan UNIQUE KEY (id_pesanan),   -- satu pengiriman per pesanan
  CONSTRAINT uq_pengiriman_resi UNIQUE KEY (no_resi),         -- NULL boleh banyak, nilai terisi unik
  CONSTRAINT fk_pengiriman_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan),
  CONSTRAINT ck_pengiriman_resi CHECK (status_pengiriman = 'dikemas' OR no_resi IS NOT NULL),   -- AB-07
  CONSTRAINT ck_pengiriman_tanggal CHECK (tgl_diterima IS NULL
                                          OR (tgl_dikirim IS NOT NULL AND tgl_diterima >= tgl_dikirim))
) ENGINE=InnoDB;

CREATE TABLE ulasan (
  id_ulasan  INT      NOT NULL AUTO_INCREMENT,
  id_pesanan INT      NOT NULL,
  id_produk  INT      NOT NULL,
  rating     TINYINT  NULL,
  komentar   TEXT     NULL,
  tgl_ulasan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_ulasan PRIMARY KEY (id_ulasan),
  CONSTRAINT fk_ulasan_pesanan FOREIGN KEY (id_pesanan) REFERENCES pesanan (id_pesanan),
  CONSTRAINT fk_ulasan_produk FOREIGN KEY (id_produk) REFERENCES produk (id_produk),
  CONSTRAINT ck_ulasan_rating CHECK (rating BETWEEN 1 AND 5)  -- NULL lolos (kamus data: rating boleh kosong)
) ENGINE=InnoDB;

-- =====================================================================
-- Aturan bisnis yang TIDAK dapat dijaga constraint (ditandai untuk Modul 14)
-- AB-01  Maksimal P+2 item per invoice: menyangkut jumlah BARIS detail per pesanan,
--        CHECK hanya melihat satu baris. Solusi: transaksi + trigger/aplikasi (Modul 14).
--        Syarat "minimal 1 item" juga lintas tabel. (Jika dosen menafsirkan batas ini
--        sebagai jumlah_beli per baris, tambahkan: CHECK (jumlah_beli <= P+2).)
-- AB-03  Penolakan saat jumlah_beli > stok_tersedia membandingkan dua tabel;
--        yang dijaga constraint baru batas bawah stok (>= 0).
-- AB-05  Voucher valid bila total_barang >= minimal_belanja dan belum kedaluwarsa:
--        butuh hitungan dari detail_pesanan -> validasi saat checkout (Modul 14).
-- AB-06  Pembatalan otomatis setelah 1x24 jam: butuh penjadwal (EVENT) / aplikasi.
-- AB-08  Ulasan hanya untuk produk yang pernah dibeli & pesanan 'selesai': lintas tabel.
-- =====================================================================
