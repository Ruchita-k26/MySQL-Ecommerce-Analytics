## Window Function Questions
# 51. Use ROW_NUMBER to rank orders.
select o.order_id,o.customer_id,t.total_amount,
row_number() over (order by t.total_amount desc) as order_rank
from (
select order_id, SUM(price) as total_amount
from order_items
group by order_id) as t
join orders o
on t.order_id = o.order_id;

# 52. Use RANK to rank sellers by revenue.

select seller_id, total_revenue,
rank() over(order by total_revenue desc) as revenue_rank
from ( 
select seller_id,sum(price) as total_revenue
from order_items
group by seller_id) as a 
;

# 53. Use DENSE_RANK for product sales.
select product_category_name, total_sale,
dense_rank() over(order by total_sale desc) as revenue_rank
from ( 
select product_category_name,count(product_id) as total_sale
from products
group by product_category_name) as a 
;

# 54. Use LAG to compare monthly sales.
Select Months, total_sales,
Lag(total_sales) over(order by Months) AS previous_month_sales
from
(select month(shipping_limit_date) as Months, sum(price) as total_sales
from order_items
group by Months) as a;

# 55. Use LEAD to forecast next month sales.
Select Months, total_sales,
Lead (total_sales) over(order by Months) AS next_month_sales
from
(select month(shipping_limit_date) as Months, sum(price) as total_sales
from order_items
group by Months) as a;

# 56. Find cumulative revenue using SUM OVER.
Select Months, total_sales,
sum(total_sales) over (order by Months) AS cumulative_sales
from
(select month(shipping_limit_date) as Months, sum(price) as total_sales
from order_items
group by Months) as a;

# 57. Calculate 3-month moving average sales.
Select Months, total_sales,
avg(total_sales) over (
order by Months
rows between 2 preceding and current row) as moving_avg_sales
from
(select month(shipping_limit_date) as Months, sum(price) as total_sales
from order_items
group by Months) as a;


# 58. Find top 5 customers per state.
select *
from(
select customer_state, customer_id, total_spent,
row_number() over (partition by customer_state order by total_spent DESC ) AS Ranks
from(
select c.customer_state, o.customer_id,
sum(oi.price) AS total_spent
from customers c
left join orders o
on c.customer_id = o.customer_id
left join order_items oi
on o.order_id = oi.order_id
group by c.customer_state, o.customer_id) AS customer_sales
) as ranked_customers
where ranks <= 5;

# 59. Find products with highest freight within category.
select product_id, product_category_name, freight_total_cost
from
( select product_id, product_category_name, freight_total_cost,
row_number() over (partition by product_category_name order by freight_total_cost desc) as rn
from
( select product_id, product_category_name, sum(freight_value) as freight_total_cost
from order_items
left join products
using(product_id)
group by product_id, product_category_name) as a
) as b
where rn = 1;

# 60. Use NTILE to segment customers(4 segments).
select customer_id, total_spent,
ntile(4) over ( order by total_spent desc ) as customer_segment
from
( select o.customer_id, sum(oi.price) as total_spent
from orders o
join order_items oi
on o.order_id = oi.order_id
group by o.customer_id
) as a;




