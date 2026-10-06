CREATE TABLE IF NOT EXISTS pengguna (
id_pengguna INT(2) NOT NULL AUTO_INCREMENT,
nama_lengkap VARCHAR(25) NOT NULL,
email VARCHAR(30) NOT NULL,
kata_sandi VARCHAR(255) NOT NULL,
no_telepon VARCHAR(12) DEFAULT NULL,
alamat TEXT DEFAULT NULL,
peran ENUM('pelanggan', 'admin') NOT NULL DEFAULT 'pelanggan',
tanggal_daftar DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id_pengguna),
UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS kategori (
id_kategori INT(2) NOT NULL AUTO_INCREMENT,
nama_kategori VARCHAR(50) NOT NULL,
slug VARCHAR(50) NOT NULL,
id_induk INT(2) DEFAULT NULL,
PRIMARY KEY (id_kategori),
UNIQUE KEY slug (slug),
KEY fk_kategori_induk (id_induk),
CONSTRAINT fk_kategori_induk FOREIGN KEY (id_induk)
REFERENCES kategori (id_kategori) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS produk (
id_produk INT(2) NOT NULL AUTO_INCREMENT,
sku VARCHAR(30) DEFAULT NULL,
nama_produk VARCHAR(50) NOT NULL,
deskripsi TEXT DEFAULT NULL,
harga DECIMAL(10,2) NOT NULL DEFAULT 0.00,
stok INT(3) NOT NULL DEFAULT 0,
berat_gram INT(2) NOT NULL DEFAULT 0,
id_kategori INT(2) DEFAULT NULL,
gambar VARCHAR(30) DEFAULT 'default.jpg',
status ENUM('aktif', 'nonaktif') NOT NULL DEFAULT 'aktif',
dibuat_pada DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (id_produk),
UNIQUE KEY sku (sku),
KEY fk_produk_kategori (id_kategori),
CONSTRAINT fk_produk_kategori FOREIGN KEY (id_kategori)
REFERENCES kategori (id_kategori) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pesanan (
id_pesanan INT(2) NOT NULL AUTO_INCREMENT,
nomor_pesanan VARCHAR(30) NOT NULL,
id_pengguna INT(2) NOT NULL,
tanggal_pesan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
total_harga DECIMAL(10,2) NOT NULL DEFAULT 0.00,
ongkos_kirim DECIMAL(8,2) NOT NULL DEFAULT 0.00,
alamat_pengiriman TEXT NOT NULL,
status_pesanan ENUM('menunggu_pembayaran', 'diproses', 'dikirim', 'selesai', 'dibatalkan') NOT NULL DEFAULT 'menunggu_pembayaran',
PRIMARY KEY (id_pesanan),
UNIQUE KEY nomor_pesanan (nomor_pesanan),
KEY fk_pesanan_pengguna (id_pengguna),
CONSTRAINT fk_pesanan_pengguna FOREIGN KEY (id_pengguna)
REFERENCES pengguna (id_pengguna) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS detail_pesanan (
id_detail INT(2) NOT NULL AUTO_INCREMENT,
id_pesanan INT(2) NOT NULL,
id_produk INT(2) NOT NULL,
jumlah INT(3) NOT NULL DEFAULT 1,
harga_satuan DECIMAL(10,2) NOT NULL DEFAULT 0.00,
subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
PRIMARY KEY (id_detail),
KEY fk_detail_pesanan (id_pesanan),
KEY fk_detail_produk (id_produk),
CONSTRAINT fk_detail_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan (id_pesanan) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_detail_produk FOREIGN KEY (id_produk)
REFERENCES produk (id_produk) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pembayaran (
id_pembayaran INT(2) NOT NULL AUTO_INCREMENT,
id_pesanan INT(2) NOT NULL,
metode_pembayaran VARCHAR(50) NOT NULL,
bukti_pembayaran VARCHAR(100) DEFAULT NULL,
jumlah_bayar DECIMAL(12,2) NOT NULL DEFAULT 0.00,
tanggal_bayar DATETIME DEFAULT NULL,
status_pembayaran ENUM('menunggu', 'diverifikasi', 'gagal') NOT NULL DEFAULT 'menunggu',
PRIMARY KEY (id_pembayaran),
KEY fk_pembayaran_pesanan (id_pesanan),
CONSTRAINT fk_pembayaran_pesanan FOREIGN KEY (id_pesanan)
REFERENCES pesanan (id_pesanan) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;