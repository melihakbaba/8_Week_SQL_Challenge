
## C - Product Analysis ##

# 1 - What are the top 3 products by total revenue before discount? #

select pd.product_name, sum(s.qty * s.price) as revenue 
from sales s 
left join product_details pd on s.prod_id = pd.product_id
group by pd.product_name
order by revenue desc
limit 3;


# 2 - What is the total quantity, revenue and discount for each segment? #

select pd.segment_name, sum(s.qty) as total_quantity , 
		sum(s.qty * s.price) as total_revenue , 
		sum(s.qty * (s.price * s.discount/100)) as total_discount
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.segment_name;

# 3 - What is the top selling product for each segment? #

with segment_prod as (select pd.segment_name,pd.product_name, sum(s.qty) as selling_quantity
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.segment_name,pd.product_name),
ranked_segment as (select *,row_number() over(partition by segment_name order by selling_quantity desc) as rank_of_selling
from segment_prod
)

select segment_name,product_name,selling_quantity
from ranked_segment
where rank_of_selling = 1;

# 4 - What is the total quantity, revenue and discount for each category? #

select pd.category_name, sum(s.qty) as total_quantity , 
		sum(s.qty * s.price) as total_revenue , 
		sum(s.qty * (s.price * s.discount/100)) as total_discount
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.category_name;

# 5 - What is the top selling product for each category? #

with category_prod as (select pd.category_name,pd.product_name,sum(qty) as selling_quantity
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.category_name,pd.product_name),
ranked_category as (select * , row_number() over(partition by category_name order by selling_quantity desc) as ranked_quantity
from category_prod)

select category_name , product_name , selling_quantity
from ranked_category
where ranked_quantity = 1;

# 6 - What is the percentage split of revenue by product for each segment? #

with revenue as (select pd.segment_name,pd.product_name , sum(s.qty * s.price) as revenue
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.segment_name,pd.product_name),
total_revenue as (select * , sum(revenue) over(partition by segment_name) as total_revenue_bysegment
from revenue)

select segment_name , product_name , (revenue / total_revenue_bysegment) as percentage_split
from total_revenue;

# 7 - What is the percentage split of revenue by segment for each category? #

with revenue as (select pd.category_name,pd.segment_name , sum(s.qty * s.price) as revenue
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.category_name,pd.segment_name),
total_revenue as (select * , sum(revenue) over(partition by category_name) as total_revenue_bysegment
from revenue)

select category_name , segment_name , (revenue / total_revenue_bysegment) as percentage_split
from total_revenue;

# 8 - What is the percentage split of total revenue by category? #

with total_revenue_cat as (select pd.category_name , sum( qty * s.price) as total_revenueby_category
from sales s
left join product_details pd on s.prod_id = pd.product_id
group by pd.category_name),
total_revenue as (select *,sum(total_revenueby_category) over() as total_revenue
from total_revenue_cat)

select category_name , (total_revenueby_category / total_revenue) as percentage_split
from total_revenue;

# 9 - What is the total transaction “penetration” for each product? #
-- (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions) 

select pd.product_name, (count(pd.product_name) / (select count(distinct txn_id) from sales)) as peneration
from sales s 
left join product_details pd on s.prod_id = pd.product_id
group by pd.product_name;

# 10 - What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction? #

with products as(
      select
        txn_id,
        product_name
      from
        sales s
        join product_details pd on s.prod_id = pd.product_id
    )
select p.product_name as product_1,
       p1.product_name as product_2,
       p2.product_name as product_3,
       count(*) as time_of_bought_together
from products p
	join products p1 on p.txn_id = p1.txn_id
	and p.product_name != p1.product_name
	join products p2 on p.txn_id = p2.txn_id
	and p.product_name != p2.product_name
	and p1.product_name != p2.product_name
group by p.product_name,
		 p1.product_name,
		 p2.product_name
order by time_of_bought_together desc
limit 1;



