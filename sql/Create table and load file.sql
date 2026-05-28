DROP DATABASE IF EXISTS ecommerce;
Create database ecommerce;
use  ecommerce;

-- Create tables
## 1. Customers
Create table customers (
customer_id varchar(50),
customer_unique_id	varchar(50),
customer_zip_code_prefix int,
customer_city  varchar(50),
customer_state varchar(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';

select * from customers;


##  2 Geolocation
create table geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

-- Load data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from geolocation;


## 3 order_items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    @shipping_limit_date,
    price,
    freight_value
)
SET shipping_limit_date =
STR_TO_DATE(@shipping_limit_date, '%Y-%m-%d %H:%i:%s');

select * from  order_items;

## 4.  Order_payments
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## 5. Order_reviews
DROP TABLE IF EXISTS order_reviews;

CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

select *from order_reviews;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE order_reviews
ADD review_creation_datetime DATETIME,
ADD review_answer_datetime DATETIME;

UPDATE order_reviews
SET
review_creation_datetime =
STR_TO_DATE(review_creation_date, '%Y-%m-%d %H:%i:%s'),

review_answer_datetime =
STR_TO_DATE(review_answer_timestamp, '%Y-%m-%d %H:%i:%s');


## 6. Orders
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

ALTER TABLE orders
ADD purchase_datetime DATETIME,
ADD approved_datetime DATETIME,
ADD delivered_carrier_datetime DATETIME,
ADD delivered_customer_datetime DATETIME,
ADD estimated_delivery_datetime DATETIME;

UPDATE orders
SET
purchase_datetime =
STR_TO_DATE(
    NULLIF(order_purchase_timestamp,''),
    '%d-%m-%y %H:%i'
),

approved_datetime =
STR_TO_DATE(
    NULLIF(order_approved_at,''),
    '%d-%m-%y %H:%i'
),

delivered_carrier_datetime =
STR_TO_DATE(
    NULLIF(order_delivered_carrier_date,''),
    '%d-%m-%y %H:%i'
),

delivered_customer_datetime =
STR_TO_DATE(
    NULLIF(order_delivered_customer_date,''),
    '%d-%m-%y %H:%i'
),

estimated_delivery_datetime =
STR_TO_DATE(
    NULLIF(order_estimated_delivery_date,''),
    '%d-%m-%y %H:%i'
);

## 7. Products
DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT NULL,
    product_description_lenght INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,
    product_length_cm DECIMAL(10,2) NULL,
    product_height_cm DECIMAL(10,2) NULL,
    product_width_cm DECIMAL(10,2) NULL
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
product_name_lenght =
CAST(NULLIF(@product_name_lenght,'') AS SIGNED),

product_description_lenght =
CAST(NULLIF(@product_description_lenght,'') AS SIGNED),

product_photos_qty =
CAST(NULLIF(@product_photos_qty,'') AS SIGNED),

product_weight_g =
CAST(NULLIF(@product_weight_g,'') AS SIGNED),

product_length_cm =
CAST(NULLIF(@product_length_cm,'') AS DECIMAL(10,2)),

product_height_cm =
CAST(NULLIF(@product_height_cm,'') AS DECIMAL(10,2)),

product_width_cm =
CAST(NULLIF(@product_width_cm,'') AS DECIMAL(10,2));

## 8. sellers
CREATE TABLE sellers (
    seller_id VARCHAR(50),
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## 9. 
CREATE TABLE product_category_name_translation(
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
