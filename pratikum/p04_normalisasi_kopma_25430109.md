# Normalisasi Kopma (Pertemuan 4)

**Nama:** Wanda Talia    
**NIM:** 25430109    
**Kelas:** D

### 1. Identifikasi anomali pada spreadsheet lama (Gambar 4.1)

| no_nota | tgl | kasir | anggota | barang | qty | harga | pemasok_brg |
|---|---|---|---|---|---|---|---|
| PJ-0142 | 24/09 | Rina | Budi S. | Pulpen Gel 0.5 | 3 | 4000 | CV Sumber ATK |
| PJ-0142 | 24/09 | Rina | Budi S. | Buku Tulis 58 | 2 | 6500 | CV Sumber ATK |
| PJ-0143 | 24/09 | Rina | - | Roti Cokelat | 1 | 5000 | UD Segar |
| PJ-0150 | 25/09 | Rina | Budi Santoso | Pulpen Gel 0.5 | 1 | 4500 | CV. Sumber A.T.K |

| Anomali | Bukti pada data |
|---|---|
| Ubah | Anggota yang sama tertulis "Budi S." (PJ-0142) dan "Budi Santoso" (PJ-0150). Pemasok yang sama tertulis "CV Sumber ATK" dan "CV. Sumber A.T.K". Memperbaiki satu nama berarti mengubah banyak baris. |
| Sisip | Barang baru (misalnya pensil) belum bisa dicatat sebelum ada penjualannya, karena baris hanya lahir dari nota. |
| Hapus | Menghapus PJ-0143 (satu-satunya baris Roti Cokelat) ikut menghapus informasi bahwa pemasoknya UD Segar. |

### 2. UNF ke 1NF

**UNF** (grup berulang barang dalam satu nota):

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

**1NF** (satu baris per barang per nota; kunci primer komposit):

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan)
PK = (no_nota_penjualan, kode_barang)
```

### 3. Dependensi fungsional (diturunkan dari aturan bisnis Pertemuan 2)

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota | AB-01 (satu nota satu nomor unik, satu tanggal, satu petugas, satu anggota/umum) |
| FD2 | kode_petugas -> nama_petugas | satu kode petugas milik satu orang |
| FD3 | no_anggota -> nama_anggota | AB-05 |
| FD4 | kode_barang -> nama_barang | satu kode satu barang |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 (harga disimpan per baris nota) |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | turunan (hitungan) |

FD yang **ditolak**: `kode_barang -> harga_satuan_detail_penjualan`. Alasannya AB-04: harga di nota bisa berbeda dari harga barang saat ini.

### 4. Menuju 2NF

Kunci tabelnya komposit (no_nota_penjualan, kode_barang), jadi saya cari atribut yang cukup ditentukan oleh salah satu bagian kunci:

- FD1 cukup ditentukan `no_nota_penjualan`, jadi saya pisah menjadi **penjualan**.
- FD4 cukup ditentukan `kode_barang`, jadi saya pisah menjadi **barang**.
- FD5 butuh seluruh kunci, jadi tetap di **detail_penjualan**.

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
           no_anggota, nama_anggota, jumlah_penjualan, diskon_penjualan,
           total_penjualan)
BARANG (kode_barang, nama_barang)
DETAIL_PENJUALAN (no_nota_penjualan, kode_barang, qty_detail_penjualan,
                  harga_satuan_detail_penjualan, subtotal_detail_penjualan)
```

### 5. Menuju 3NF

Di PENJUALAN ada dua rantai A → B → C:

- no_nota_penjualan -> kode_petugas -> nama_petugas (FD1 + FD2)
- no_nota_penjualan -> no_anggota -> nama_anggota (FD1 + FD3)

Karena itu **petugas** dan **anggota** saya pisah menjadi tabel sendiri.

### 6. Keputusan nilai turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | Tidak disimpan | = qty x harga satuan; bila qty/harga dikoreksi, nilai tersimpan bisa tidak cocok |
| jumlah_penjualan | Tidak disimpan | = jumlah subtotal seluruh detail nota |
| diskon_penjualan | Tidak disimpan | ditentukan status anggota (AB-02: 5% bila aktif) |
| total_penjualan | Tidak disimpan | = jumlah - diskon |
| bayar_penjualan | **Disimpan** | uang yang benar-benar diterima kasir; bukan hasil hitungan |

### 7. Hasil akhir 3NF

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
-- PK dicetak sebagai kolom pertama (atau gabungan), * = kunci tamu
```

**Tabel tahapan (untuk tangkapan layar bukti):**

| Tahap | Relasi hasil | Masalah yang dihilangkan |
|---|---|---|
| UNF | NOTA_UNF | - (grup berulang barang) |
| 1NF | NOTA_1NF (PK komposit) | grup berulang |
| 2NF | PENJUALAN, BARANG, DETAIL_PENJUALAN | ketergantungan parsial (FD1, FD4) |
| 3NF | PENJUALAN, DETAIL_PENJUALAN, BARANG, PETUGAS, ANGGOTA | ketergantungan transitif (FD2, FD3) + nilai turunan dibuang |


### 8. Pencocokan dengan skema kanonik Kopma (Tabel 4.2) dan pemeriksaan BCNF

Beda utamanya dengan hasil saya: skema kanonik memakai **kunci pengganti `id_*`** sebagai kunci primer, sedangkan kode alami (`kode_petugas`, `no_anggota`, `nim_anggota`, `kode_barang`, `no_nota_penjualan`) dijadikan **kunci unik**. Skema kanonik juga punya pemasok, pembelian, dan detail_pembelian (dari faktur pemasok), jadi totalnya 8 tabel.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

**Pemeriksaan BCNF (apakah setiap penentu adalah kunci kandidat):**

| Tabel | Penentu yang ada | Kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | Ya, keduanya | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | Ya, ketiganya | BCNF |
| barang | id_barang, kode_barang | Ya, keduanya | BCNF |
| pemasok | id_pemasok | Ya | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | Ya, keduanya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | Ya | BCNF |
| pembelian | id_pembelian | Ya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | Ya | BCNF |

Kunci pengganti tidak otomatis membuat tabel 3NF, jadi saya tetap memeriksa dengan kunci alami (misalnya `nim_anggota` di anggota). Hasilnya semua tabel sudah BCNF.
