digraph G {
  graph [rankdir=LR, fontname="Helvetica", nodesep=0.5, ranksep=1.1, pad=0.3, bgcolor="white"];
  node [shape=plaintext, fontname="Helvetica", fontsize=10];
  edge [fontname="Helvetica", fontsize=9, color="#555555", arrowhead=crow, arrowtail=tee, dir=both];

  petugas [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>petugas</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_petugas</TD><TD ALIGN="LEFT">smallint(6)</TD></TR>
    <TR><TD ALIGN="LEFT">kode_petugas</TD><TD ALIGN="LEFT">char(3)</TD></TR>
    <TR><TD ALIGN="LEFT">nama_petugas</TD><TD ALIGN="LEFT">varchar(100)</TD></TR>
    <TR><TD ALIGN="LEFT">peran_petugas</TD><TD ALIGN="LEFT">enum('kasir','gudang','ketua')</TD></TR>
  </TABLE>>];

  anggota [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>anggota</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_anggota</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">no_anggota</TD><TD ALIGN="LEFT">char(6)</TD></TR>
    <TR><TD ALIGN="LEFT">nim_anggota</TD><TD ALIGN="LEFT">char(10)</TD></TR>
    <TR><TD ALIGN="LEFT">nama_anggota</TD><TD ALIGN="LEFT">varchar(100)</TD></TR>
    <TR><TD ALIGN="LEFT">prodi_anggota</TD><TD ALIGN="LEFT">varchar(60)</TD></TR>
    <TR><TD ALIGN="LEFT">no_hp_anggota</TD><TD ALIGN="LEFT">varchar(15)</TD></TR>
    <TR><TD ALIGN="LEFT">status_anggota</TD><TD ALIGN="LEFT">enum('aktif','nonaktif')</TD></TR>
    <TR><TD ALIGN="LEFT">tgl_daftar_anggota</TD><TD ALIGN="LEFT">date</TD></TR>
  </TABLE>>];

  barang [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>barang</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_barang</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">kode_barang</TD><TD ALIGN="LEFT">varchar(10)</TD></TR>
    <TR><TD ALIGN="LEFT">nama_barang</TD><TD ALIGN="LEFT">varchar(100)</TD></TR>
    <TR><TD ALIGN="LEFT">kategori_barang</TD><TD ALIGN="LEFT">enum('ATK','makanan','minuman')</TD></TR>
    <TR><TD ALIGN="LEFT">harga_jual_barang</TD><TD ALIGN="LEFT">decimal(12,2)</TD></TR>
    <TR><TD ALIGN="LEFT">stok_barang</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">stok_min_barang</TD><TD ALIGN="LEFT">int(3)</TD></TR>
  </TABLE>>];

  pemasok [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>pemasok</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_pemasok</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">nama_pemasok</TD><TD ALIGN="LEFT">varchar(100)</TD></TR>
    <TR><TD ALIGN="LEFT">telepon_pemasok</TD><TD ALIGN="LEFT">varchar(15)</TD></TR>
    <TR><TD ALIGN="LEFT">alamat_pemasok</TD><TD ALIGN="LEFT">varchar(200)</TD></TR>
  </TABLE>>];

  penjualan [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>penjualan</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_penjualan</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">no_nota_penjualan</TD><TD ALIGN="LEFT">char(12)</TD></TR>
    <TR><TD ALIGN="LEFT">tgl_penjualan</TD><TD ALIGN="LEFT">datetime</TD></TR>
    <TR><TD ALIGN="LEFT">id_petugas</TD><TD ALIGN="LEFT">smallint(6)</TD></TR>
    <TR><TD ALIGN="LEFT">id_anggota</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">bayar_penjualan</TD><TD ALIGN="LEFT">decimal(12,2)</TD></TR>
  </TABLE>>];

  detail_penjualan [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>detail_penjualan</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_penjualan</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">id_barang</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">qty_detail_penjualan</TD><TD ALIGN="LEFT">smallint(6)</TD></TR>
    <TR><TD ALIGN="LEFT">harga_satuan_detail_penjualan</TD><TD ALIGN="LEFT">decimal(12,2)</TD></TR>
  </TABLE>>];

  pembelian [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>pembelian</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_pembelian</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">no_faktur_pembelian</TD><TD ALIGN="LEFT">varchar(20)</TD></TR>
    <TR><TD ALIGN="LEFT">tgl_pembelian</TD><TD ALIGN="LEFT">date</TD></TR>
    <TR><TD ALIGN="LEFT">id_pemasok</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">status_pembelian</TD><TD ALIGN="LEFT">enum('dipesan','diterima')</TD></TR>
  </TABLE>>];

  detail_pembelian [label=<<TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="3">
    <TR><TD BGCOLOR="#2f5d8a" COLSPAN="2"><FONT COLOR="white"><B>detail_pembelian</B></FONT></TD></TR>
    <TR><TD ALIGN="LEFT">id_pembelian</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">id_barang</TD><TD ALIGN="LEFT">int(3)</TD></TR>
    <TR><TD ALIGN="LEFT">qty_detail_pembelian</TD><TD ALIGN="LEFT">int(2)</TD></TR>
    <TR><TD ALIGN="LEFT">harga_beli_detail_pembelian</TD><TD ALIGN="LEFT">decimal(12,2)</TD></TR>
  </TABLE>>];

  petugas -> penjualan;
  anggota -> penjualan;
  penjualan -> detail_penjualan;
  barang -> detail_penjualan;
  pemasok -> pembelian;
  pembelian -> detail_pembelian;
  barang -> detail_pembelian;
}