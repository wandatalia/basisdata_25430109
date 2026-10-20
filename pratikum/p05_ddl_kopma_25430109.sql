USE kopma_109;

-- ---------------------------------------------------------------------
-- Hapus ulang (urutan anak -> induk) agar skrip dapat dijalankan berulang
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

-- ---------------------------------------------------------------------
-- Tabel master (tanpa kunci tamu)
-- ---------------------------------------------------------------------
CREATE TABLE petugas (
  id_petugas    SMALLINT                      NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(3)                       NOT NULL,   -- kode singkat di nota, mis. K03
  nama_petugas  VARCHAR(100)                  NOT NULL,
  peran_petugas ENUM('kasir','gudang','ketua') NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE KEY (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota         INT          NOT NULL AUTO_INCREMENT,
  no_anggota         CHAR(6)      NOT NULL,                -- nomor kartu, mis. A-0457
  nim_anggota        CHAR(10)     NOT NULL,                -- kode, bukan angka untuk dihitung
  nama_anggota       VARCHAR(100) NOT NULL,
  prodi_anggota      VARCHAR(60)  NOT NULL,
  no_hp_anggota      VARCHAR(15)  NULL,                    -- DATA PRIBADI (UU PDP), boleh kosong
  status_anggota     ENUM('aktif','nonaktif') NOT NULL,    -- AB-02: hanya 'aktif' dapat diskon 5%
  tgl_daftar_anggota DATE         NOT NULL,
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no  UNIQUE KEY (no_anggota),       -- AB-05
  CONSTRAINT uq_anggota_nim UNIQUE KEY (nim_anggota)       -- AB-05
) ENGINE=InnoDB;

CREATE TABLE barang (
  id_barang         INT                             NOT NULL AUTO_INCREMENT,
  kode_barang       VARCHAR(10)                     NOT NULL,   -- mis. ATK-001
  nama_barang       VARCHAR(100)                    NOT NULL,
  kategori_barang   ENUM('ATK','makanan','minuman') NOT NULL,
  harga_jual_barang DECIMAL(12,2)                   NOT NULL,   -- uang: DECIMAL, bukan FLOAT
  stok_barang       INT                             NOT NULL DEFAULT 0,
  stok_min_barang   INT                             NOT NULL DEFAULT 5,   -- batas pesan ulang (AB-06)
  CONSTRAINT pk_barang PRIMARY KEY (id_barang),
  CONSTRAINT uq_barang_kode UNIQUE KEY (kode_barang),
  CONSTRAINT ck_barang_stok  CHECK (stok_barang >= 0),          -- AB-03
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok      INT          NOT NULL AUTO_INCREMENT,
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15)  NULL,
  alamat_pemasok  VARCHAR(200) NULL,
  CONSTRAINT pk_pemasok PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Tabel transaksi (dengan kunci tamu). Tipe kunci tamu = tipe kolom induk.
-- ---------------------------------------------------------------------
CREATE TABLE penjualan (
  id_penjualan      INT           NOT NULL AUTO_INCREMENT,
  no_nota_penjualan CHAR(12)      NOT NULL,          -- format PJ-YYMM-nnnn
  tgl_penjualan     DATETIME      NOT NULL,          -- jam dibutuhkan untuk laporan harian (KI-01)
  id_petugas        SMALLINT      NOT NULL,
  id_anggota        INT           NULL,              -- AB-02: NULL = pembeli umum
  bayar_penjualan   DECIMAL(12,2) NOT NULL,          -- uang diterima; total TIDAK disimpan (Modul 4)
  CONSTRAINT pk_penjualan PRIMARY KEY (id_penjualan),
  CONSTRAINT uq_penjualan_nota UNIQUE KEY (no_nota_penjualan),  -- AB-01
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota)
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
  id_penjualan                  INT           NOT NULL,
  id_barang                     INT           NOT NULL,
  qty_detail_penjualan          SMALLINT      NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,          -- AB-04: salinan harga saat transaksi
  CONSTRAINT pk_detail_penjualan PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan)
    REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,        -- nota batal -> rincian ikut hilang
  CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0)
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian       INT         NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(20) NOT NULL,          -- dari pemasok; sengaja TIDAK unik
  tgl_pembelian      DATE        NOT NULL,
  id_pemasok         INT         NOT NULL,
  status_pembelian   ENUM('dipesan','diterima') NOT NULL,   -- AB-06
  CONSTRAINT pk_pembelian PRIMARY KEY (id_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
  id_pembelian               INT           NOT NULL,
  id_barang                  INT           NOT NULL,
  qty_detail_pembelian       INT           NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,        -- harga modal per unit
  CONSTRAINT pk_detail_pembelian PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_detail_pembelian FOREIGN KEY (id_pembelian)
    REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_pembelian_qty CHECK (qty_detail_pembelian > 0)
) ENGINE=InnoDB;

-- Pemeriksaan hasil:
-- SHOW TABLES;
-- SHOW CREATE TABLE penjualan;
