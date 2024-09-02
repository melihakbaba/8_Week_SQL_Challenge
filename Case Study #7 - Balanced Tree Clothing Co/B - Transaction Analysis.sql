
## B - Transaction Analysis ##

# 1 - How many unique transactions were there? #

select count(distinct txn_id) as n_unique_transaction
from sales;

# 2 - What is the average unique products purchased in each transaction? #

select count(prod_id) / count(distinct txn_id) as avg_unique_products
from sales;

 # 3 - What are the 25th, 50th and 75th percentile values for the revenue per transaction? #
 
 with revenue_per_trans as (select txn_id , sum(qty * price) as revenue
 from sales
 group by txn_id),
 percentaged as (select * , percent_rank() over(order by revenue) as percentile
 from revenue_per_trans)
 
 -- for 25th percentile
 select revenue
 from percentaged
 where percentile > 0.25
 limit 1 ;
 
  -- for 50th percentile
   with revenue_per_trans as (select txn_id , sum(qty * price) as revenue
 from sales
 group by txn_id),
 percentaged as (select * , percent_rank() over(order by revenue) as percentile
 from revenue_per_trans)
 
 select revenue
 from percentaged
 where percentile > 0.50
 limit 1 ;
 
  -- for 75th percentile
   with revenue_per_trans as (select txn_id , sum(qty * price) as revenue
 from sales
 group by txn_id),
 percentaged as (select * , percent_rank() over(order by revenue) as percentile
 from revenue_per_trans)
 
 select revenue
 from percentaged
 where percentile > 0.75
 limit 1 ;
 
 # 4 - What is the average discount value per transaction? #
 
 with discounted as (select txn_id , sum(qty * (price * discount/100)) as discounted_price
 from sales
 group by txn_id)
 
 select avg(discounted_price) as avg_discount_value
 from discounted;
 
 # 5 - What is the percentage split of all transactions for members vs non-members? #
 
 with membered_trans as (select member,count(distinct txn_id) as n_transactions
 from sales
 group by member),
 total_trans as (select member,n_transactions,sum(n_transactions) over() as total_transactions
from membered_trans)

select member, n_transactions / total_transactions as percentage_of_transactions
from total_trans;

# 6 - What is the average revenue for member transactions and non-member transactions? #

with revenued as (select member, txn_id, sum(qty * price) as total_revenue
from sales	
group by member,txn_id)

select member,avg(total_revenue) as avg_revenue
from revenued
group by member;