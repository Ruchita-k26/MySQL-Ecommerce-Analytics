describe customers;
Alter Table customers
add primary key (customer_id);

describe orders;
Alter Table orders
add primary key (order_id);

describe products;
Alter Table products
add primary key (product_id);

describe sellers;
Alter Table sellers
add primary key (seller_id);

ALTER TABLE order_payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


ALTER TABLE order_reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);



ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_product_items
FOREIGN KEY (product_id)
REFERENCES products(product_id);


ALTER TABLE order_items
ADD CONSTRAINT fk_items_seller
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);


