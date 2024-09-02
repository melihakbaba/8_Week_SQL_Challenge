
## A - High Level Sales Analysis ##

# 1 - What was the total quantity sold for all products? #

select sum(qty) as quantity_of_products 
from sales ;

# 2 - What is the total generated revenue for all products before discounts? #

select sum(qty*price) as total_revenue 
from sales;

# 3 - What was the total discount amount for all products? #

with prices as (select qty,price,(price)-(price * (discount/100)) as discounted_price
from sales)

select  sum(qty*price) as total_revenue , 
		sum(qty * discounted_price) as total_revenue_after_discount , 
        sum(qty*price) - sum(qty * discounted_price) as total_discount_amount
from prices;