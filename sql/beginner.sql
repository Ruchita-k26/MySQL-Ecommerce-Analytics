-- 1.Find total customers by state.
select customer_state, count(*) total_customers
from customers
group by customer_state;

-- 2.Count total sellers in each city.
select seller_city, count(*) total_sellers
from sellers
group by seller_city
order by total_sellers desc;

-- 3. Find average product price.
select avg(price) as   average_product_price
from order_items;

select avg(payment_value) as   average_product_price
from order_payments;

-- 4. List top 10 most expensive products.
select product_category_name, price
from order_items as ot
join products as p
on ot.product_id = p.product_id
order by ot.price desc
limit 10;

-- 5.Count reviews by review score.
select review_score, count(*) as `total count of reviews`
from order_reviews
group by review_score
order by `total count of reviews` desc;

-- 6. Find total orders placed each month.
select month(order_purchase_timestamp), count(*) as `total order placed`
from orders
group by month(order_purchase_timestamp)
order by month(order_purchase_timestamp) asc;

select year(order_purchase_timestamp), month(order_purchase_timestamp), count(*) as `total order placed`
from orders
group by year(order_purchase_timestamp), month(order_purchase_timestamp)
order by month(order_purchase_timestamp) asc;

-- 7. Show all unique product categories.
select distinct product_category_name
from products;

-- 8. Find customers from Sao Paulo.
select customer_unique_id
from customers
where customer_city = 'sao paulo';



-- 9. Calculate average freight value.
select avg(freight_value)
from order_items;


-- 10. Find products with weight greater than 1000g.
select product_id, product_category_name,product_weight_g
from products
where product_weight_g > 1000;

-- 11. Count products per category.
select p.product_category_name,product_category_name_english, count(*)
from order_items as ot
join products  as p
using (product_id)
join product_category_name_translation as pc
using (product_category_name)
group by product_category_name, product_category_name_english;

-- 12. Show orders with freight value above average.
select * 
from order_items 
where freight_value > ( select avg(freight_value) from order_items);  

-- 13. Find minimum and maximum product price.
select  min(payment_value), max(payment_value)
from order_payments ;

SELECT *
FROM order_payments
WHERE payment_value = (
    SELECT MIN(payment_value)
    FROM order_payments
)
OR payment_value = (
    SELECT MAX(payment_value)
    FROM order_payments
);

-- 14. Find total revenue generated.
select sum(payment_value) as total_revenue
from order_payments;

-- 15. Show sellers from SP state.
select * 
from sellers
where seller_state = 'SP';

-- 16. Find products with more than 3 photos.
select * 
from products
where product_photos_qty > 3;

-- 17. Count total orders per customer.
select  customer_id,count(order_id)
from orders
group by customer_id;

-- 18. Find customers whose zip code starts with 13.
select  *
from customers
where customer_zip_code_prefix like '13%';

-- 19. List all review comments with score 1.
select * 
from order_reviews
where review_score = 1;

-- 20. Find orders with multiple items.
select order_id,count(*) as `total items`
from order_items
group by order_id
having count(*) > 1;
