## Advanced SQL with CTE
# 41. Use a CTE to calculate monthly revenue.
with months as(
select month(order_purchase_timestamp) as month_of_purchase,order_id
from orders)

select month_of_purchase , sum(price) as monthly_revenue
from months 
left join order_items
using(order_id)
group by month_of_purchase
order by month_of_purchase desc;

### OR

with revenue as (
select 
month(order_purchase_timestamp) as month,price
from orders
left join order_items
using(order_id)
)

select 
month, sum(price) as monthly_revenue
from revenue
group by month
order by month desc;

# 42. Calculate customer lifetime value.
with customer_revenue as (
select customer_id, sum(price) as total_spent
from orders
left join order_items
using(order_id)
group by customer_id
)

select customer_id, total_spent as customer_lifetime_value
from customer_revenue
order by customer_lifetime_value desc;

# 43. Find seller revenue ranking.
with seller_revenue as (
select seller_id, sum(price) as total_revenue
from order_items
group by seller_id
)

select seller_id, total_revenue,
rank() over(order by total_revenue desc) as revenue_rank
from seller_revenue;

# 44. Find top 3 products per category.
with product_sales as (
select product_category_name, product_id,
sum(price) as total_sales
from products
left join order_items
using(product_id)
group by product_category_name, product_id
),

ranked_products as (
select product_category_name, product_id, total_sales,
Rank() over(partition by product_category_name order by total_sales desc) as ranking
from product_sales
)

select product_category_name, product_id, total_sales, ranking
from ranked_products
where ranking <= 3;

# 45. Find month-over-month growth.
with monthly_sales as (
select month(order_purchase_timestamp) as month,
sum(price) as total_sales
from orders
left join order_items
using(order_id)
group by month(order_purchase_timestamp)
)

select month, total_sales,
lag(total_sales) over(order by month) as previous_month_sales,
round(
((total_sales - lag(total_sales) over(order by month)) 
/ lag(total_sales) over(order by month)) * 100, 2
) as mom_growth_percentage
from monthly_sales;

# 47. Calculate rolling 3-month sales average.
with monthly_sales as (
select month(order_purchase_timestamp) as month,
sum(price) as total_sales
from orders
left join order_items
using(order_id)
group by month(order_purchase_timestamp)
)

select month, total_sales,
avg(total_sales) over(order by month
rows between 2 preceding and current row
) as rolling_3_month_avg
from monthly_sales;


# 48. Find categories contributing 80% of sales.
with category_sales as (
select product_category_name,
sum(price) as total_sales
from products
left join order_items
using(product_id)
group by product_category_name
),

sales_contribution as (
select product_category_name, total_sales,
sum(total_sales) over(order by total_sales desc) as cumulative_sales,
sum(total_sales) over() as overall_sales
from category_sales
)

select product_category_name, total_sales,
round((cumulative_sales / overall_sales) * 100, 2) as cumulative_percentage
from sales_contribution
where (cumulative_sales / overall_sales) * 100 <= 80;

# 49. Find customers with declining purchase frequency.
with customer_orders as (
select customer_id,
month(order_purchase_timestamp) as month,
count(order_id) as total_orders
from orders
group by customer_id, month(order_purchase_timestamp)
),

purchase_trend as (
select customer_id, month, total_orders,
lag(total_orders) over(
partition by customer_id
order by month
) as previous_orders
from customer_orders
)

select customer_id, month, total_orders, previous_orders
from purchase_trend
where total_orders < previous_orders;

# 50. Create monthly cohort analysis.
with customer_cohort as (
select customer_id,
min(month(order_purchase_timestamp)) as cohort_month
from orders
group by customer_id
),

customer_activity as (
select customer_id,
month(order_purchase_timestamp) as order_month
from orders
),

cohort_data as (
select cc.customer_id,
cc.cohort_month,
ca.order_month,
(ca.order_month - cc.cohort_month) as month_number
from customer_cohort cc
join customer_activity ca
on cc.customer_id = ca.customer_id
)

select cohort_month,
month_number,
count(distinct customer_id) as customers
from cohort_data
group by cohort_month, month_number
order by cohort_month, month_number;
