# SQL Practice: Analisis Transaksi Retail
Latihan SQL (MariaDB) pada data transaksi retail. Repository ini untuk latihan teknik, bukan untuk pengambilan keputusan bisnis.

## Sumber Data
- **Dataset:** Retail Transaction Dataset
- **Sumber:** https://www.kaggle.com/datasets/fahadrehman07/retail-transaction-dataset
- **Lisensi:** CC BY-NC-ND 4.0 (https://creativecommons.org/licenses/by-nc-nd/4.0/). Pemakaian hanya untuk non-komersial dan tanpa turunan.
- **Catatan:** file CSV tidak disertakan di repository ini. Unduh sendiri dari sumber di atas.

## Struktur Repository
```
sql-practice/
├── README.md
├── schema.sql      # pembuatan tabel
├── load_data.sql   # impor CSV
└── queries.sql     # kumpulan query analisis
```

## Cara Menyiapkan
1. **Siapkan CSV yang sudah dibersihkan.** Dataset asli memiliki enter di dalam kolom `StoreLocation`, yang membuat impor salah. Jalankan perintah ini di folder yang berisi CSV asli:
   ```
   python -c "import pandas as pd; df=pd.read_csv('Retail_Transaction_Dataset.csv'); df['StoreLocation']=df['StoreLocation'].str.replace('\n',' ',regex=False); df.columns=['customer_id','product_id','quantity','price','transaction_date','payment_method','store_location','product_category','discount_pct','total_amount']; df.to_csv('transaksi_bersih.csv',index=False)"
   ```
2. **Buat database dan tabel:**
   ```
   CREATE DATABASE latihan;
   USE latihan;
   SOURCE schema.sql;
   ```
3. **Impor data.** Buka `load_data.sql`, lalu ganti path file dengan lokasi `transaksi_bersih.csv` di komputermu. Jalankan dengan `mysql --local-infile=1`.
4. **Verifikasi:** `SELECT COUNT(*) FROM transactions;` harus menghasilkan `100000`.
5. **Jalankan query** dari `queries.sql`.

## Daftar Query dan Temuan
### 1a. Validasi: metode pembayaran kosong
**Pertanyaan:** Berapa baris dengan `payment_method` kosong atau NULL?
**Hasil:** `total_missing_payment = 0`
**Temuan:** Tidak ada baris dengan metode pembayaran yang hilang.

### 1b. Validasi: diskon ekstrem
**Pertanyaan:** Berapa baris dengan `discount_pct` di atas 50?
**Hasil:** `total_high_discount = 0`
**Temuan:** Tidak ada transaksi dengan diskon di atas 50%.

### 2. Agregasi: total pendapatan per kategori
**Pertanyaan:** Berapa total `total_amount` per `product_category`, diurutkan dari yang terbesar?
**Hasil:**

| product_category | total_all_amount |
|---|---|
| Books | 6.257.836,83 |
| Clothing | 6.205.502,49 |
| Electronics | 6.196.734,07 |
| Home Decor | 6.173.421,27 |

**Temuan:** Books memiliki total tertinggi, tetapi selisih antara kategori tertinggi dan terendah hanya sekitar 1,4%, sehingga tidak ada kategori yang mendominasi.

### 3. HAVING: metode pembayaran di atas rata-rata
**Pertanyaan:** Metode pembayaran mana yang rata-rata nilai transaksinya di atas rata-rata seluruh transaksi?
**Pembanding:** rata-rata seluruh transaksi dihitung dengan subquery, bukan angka tetap.
**Hasil:**

| payment_method | avg_transaction_value |
|---|---|
| Debit Card | 249,21 |

**Temuan:** Hanya Debit Card yang berada di atas rata-rata seluruh transaksi (sekitar 248,33), dengan selisih sekitar 0,4%. Selisih ini terlalu kecil untuk disimpulkan sebagai perbedaan perilaku pembayaran.

### 4. Subquery: transaksi di atas rata-rata per kategori
**Pertanyaan:** Berapa banyak transaksi per kategori yang nilainya di atas rata-rata seluruh transaksi?
**Hasil:**

| product_category | total_transactions |
|---|---|
| Books | 10.456 |
| Clothing | 10.321 |
| Electronics | 10.315 |
| Home Decor | 10.231 |

Total 41.323 transaksi, atau sekitar 41% dari 100.000.

**Temuan:** Jumlah transaksi di atas rata-rata hampir sama di keempat kategori. Sekitar 41% transaksi berada di atas rata-rata, yang wajar karena distribusi nilai transaksinya tidak simetris.

## Catatan Keterbatasan
- **Format tanggal campur dan tidak bisa dipastikan.** Ada pola `M/D/YYYY` dan pola dengan tanda hubung yang urutan hari dan bulannya ambigu. Kolom `transaction_date` disimpan sebagai `VARCHAR` dan tidak dipakai untuk analisis tren.
- **Data tampak sintetis.** Distribusi kategori, metode pembayaran, dan ProductID hampir rata, dan ProductID tidak berpasangan dengan kategori. Hasil di atas menunjukkan teknik, bukan perilaku pelanggan yang sebenarnya.
- **Pembulatan harga.** `price` disimpan sebagai `DECIMAL(10,2)`, sedangkan nilai aslinya memiliki 8 desimal. Selisih kecil pada `total_amount` bisa muncul karena pembulatan ini.
- **Tujuan:** latihan teknik SQL. Jangan dipakai sebagai dasar keputusan bisnis.