-- 1. Validasi data
-- 1a. Validasi: metode pembayaran kosong
-- Menghitung baris yang metode pembayaran-nya kosong
SELECT 
    COUNT(*) AS total_missing_payment
FROM transactions
WHERE payment_method IS NULL OR payment_method = '';

-- 1b. Validasi: diskon ekstrem
-- Cek baris yang persentase diskon-nya di atas 50
SELECT 
    COUNT(*) AS total_high_discount
FROM transactions
WHERE discount_pct > 50;

-- 2. Agregasi dasar
-- Menghitung total pendapatan per kategori produk dan mengurutkan dari yang terbesar
SELECT 
    product_category,
    SUM(total_amount) AS total_all_amount
FROM transactions
GROUP BY product_category;

-- 3. HAVING
-- Mencari metode pembayaran yang rata-rata nilai transaksinya di atas nilai rata-rata seluruh transaksi
SELECT
    payment_method,
    AVG(total_amount) AS avg_transaction_value
FROM transactions
GROUP BY payment_method
HAVING AVG(total_amount) > (SELECT AVG(total_amount) FROM transactions);

-- 4. Subquery
-- Menghitung banyak transaksi yang nilainya di atas rata-rata seluruh transaksi dan mencari ke kategori mana transaksi itu terbagi
SELECT 
    product_category,
    COUNT(*) AS total_transactions
FROM transactions
WHERE total_amount > (SELECT AVG(total_amount) FROM transactions)
GROUP BY product_category
ORDER BY total_transactions DESC;