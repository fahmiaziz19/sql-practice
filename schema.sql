DROP TABLE IF EXISTS transactions;

CREATE Table transactions (
    customer_id int,
    product_id varchar(30),
    quantity int,
    price decimal(10,2),
    transaction_date varchar(20),
    payment_method varchar(20),
    store_location varchar(100),
    product_category varchar(20),
    discount_pct decimal(5,2),
    total_amount decimal(12,2)
);