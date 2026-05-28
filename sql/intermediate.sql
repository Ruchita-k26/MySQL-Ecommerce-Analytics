## Intermediate SQL

## 21. Find top 5 cities by total customers.
select customer_city, count(customer_unique_id) as total_customers
from customers
group by customer_city
order by total_customers desc
limit 5;

## 22. Calculate revenue by seller.
select seller_id, sum(price) as `total revenue by sellers`
from order_items 
group by seller_id;

## 23. Find average order value by state.
select customer_state, SUM(price) / COUNT(DISTINCT orders.order_id) AS avg_order_value
from orders
join order_items
using (order_id)
join customers 
using (customer_id)
group by customer_state;

## 24. Show top 10 selling product categories.
select product_category_name ,sum(price) as total_sales
from order_items
join products
using(product_id)
group by product_category_name
order by sum(price) desc
limit 10; 

## 25. Find customers with more than 5 orders.
select customer_unique_id,count(order_id) as total_order
from customers 
join orders 
using(customer_id)
group by customer_unique_id
having total_order >5;

## 26. Calculate average review score by category.
select product_category_name, avg(review_score) as average_review_score
from order_items
join order_reviews
using (order_id)
join products 
using (product_id)
group by product_category_name;

## 27. Find top 10 sellers by revenue.
select seller_id, sum(price) as revenue
from order_items
group by seller_id
order by revenue desc
limit 10;

## 28. Show monthly sales trend.
SELECT month(order_purchase_timestamp) as month ,
    SUM(price) AS total_sales
from orders
join order_items
using(order_id)
group by month(order_purchase_timestamp)
order by total_sales desc;

## 29. Find products never ordered.

select p.product_category_name, count(oi.order_id) as orders
from products p
left join order_items oi
on p.product_id = oi.product_id
group by p.product_category_name
having count(oi.order_id) = 0;

select count(*) as total_products
from products;

select count(distinct product_id) as ordered_products
from order_items;

## 30. Calculate average delivery delay.
select avg(datediff(delivered_customer_datetime,estimated_delivery_datetime)) as avg_delivery_delay
from orders;                   ### +ve --> delayed  ;  -ve --> early delivery

select avg(datediff(delivered_customer_datetime,estimated_delivery_datetime)) as avg_delay
from orders
where delivered_customer_datetime > estimated_delivery_datetime;                         

## 31. Find orders delivered late.
select order_id, datediff(delivered_customer_datetime,estimated_delivery_datetime) as delay_days
from orders
where datediff(delivered_customer_datetime,estimated_delivery_datetime) >0;

## 32. Show top 10 customers by spending.
select customer_unique_id , sum(price+freight_value) as total_spending
from customers
left join orders
using(customer_id)
left join order_items
using(order_id)
group by customer_unique_id
order by total_spending desc
limit 10;

## 33. Find category with highest freight cost.
select product_category_name_english, sum(freight_value) as total_freight_cost
from product_category_name_translation
left join products
using (product_category_name)
left join order_items
using (product_id)
group by product_category_name_english
order by total_freight_cost desc
limit 1;

## 34. Calculate revenue contribution by state.
select customer_state, sum(payment_value) as Revenue_by_state
from customers
left join orders
using(customer_id)
left join order_payments
using(order_id)
group by customer_state;


## 35. Find customers with no reviews.
select customer_id
from orders
left join order_reviews
using(order_id)
where review_id is null;

## 36. Show sellers with average rating below 3.
select seller_id, avg(review_score) as avg_rating
from order_items
join order_reviews
using(order_id)
group by seller_id
having avg(review_score) < 3;

## 37. Find most reviewed 10 products.
select product_category_name, count(*) as no_of_reviews
from products
left join order_items
using(product_id)
left join order_reviews
using(order_id)
group by product_category_name
order by no_of_reviews desc
limit 10;

## 38. Calculate average products per order.
select avg(product_count) as avg_products_per_order
from (select order_id,count(product_id) as product_count
from order_items
group by order_id) as order_products;

## 39. Show categories with highest average price.
select product_category_name, avg(price) as avg_price
from products
left join order_items
using(product_id)
group by product_category_name
order by avg_price desc
limit 1;

## 40. Find sellers operating in multiple states.
select seller_id, count(distinct seller_state) as no_of_states
from sellers
group by seller_id
having count(distinct seller_state) > 1;
