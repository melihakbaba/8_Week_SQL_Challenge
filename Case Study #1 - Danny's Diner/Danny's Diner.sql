# 1 - What is the total amount each customer spent at the restaurant? #
select customer_id,sum(price) as per_spent from sales s 
left join menu m on s.product_id = m.product_id
group by customer_id;

# 2 - How many days has each customer visited the restaurant? #
with visitors  as (select distinct order_date,customer_id from sales)

select customer_id,count(order_date) as visit_times 
from visitors 
group by customer_id;

# 3 - What was the first item from the menu purchased by each customer? #

with customer_first as (select customer_id,product_name,row_number() over(partition by customer_id order by order_date ) as rank_num 
from sales s left join menu m on s.product_id = m.product_id)

select customer_id,product_name 
from customer_first cf 
where rank_num = 1;

# 4 - What is the most purchased item on the menu and how many times was it purchased by all customers? # 

select s.product_id,m.product_name,count(s.product_id) as count_of_prod from sales s 
left join menu m on s.product_id = m.product_id 
group by product_id,product_name
order by count_of_prod DESC
Limit 1;

# 5 - Which item was the most popular for each customer? #

with item_with_count as (select s.customer_id,m.product_name,count(product_name) as count_item
from sales s 
left join menu m on s.product_id = m.product_id 
group by customer_id,product_name 
)

select customer_id,product_name
from (select *,rank() over(partition by customer_id order by count_item desc) as popular 
	  from item_with_count) as pp
where popular = 1;

# 6 - Which item was purchased first by the customer after they became a member? #

select dd.customer_id,product_name,order_date 
from (select s.customer_id,m.product_name,order_date ,row_number() over(partition by s.customer_id order by order_date asc) as first_item
from sales s
left join members mem on s.customer_id = mem.customer_id 
left join menu m on s.product_id=m.product_id
where order_date>=join_date) as dd
where first_item = 1;

# 7 - Which item was purchased just before the customer became a member? #

select dd.customer_id,product_name,order_date,last_item 
from (select s.customer_id,me.product_name,order_date ,rank() over(partition by s.customer_id order by order_date desc) as last_item  
from sales s 
left join members m on s.customer_id = m.customer_id 
left join menu me on s.product_id=me.product_id
where order_date< join_date) as dd
where last_item = 1;

# 8 - What is the total items and amount spent for each member before they became a member? #

select customer_id,count(product_name) as total_items ,sum(price) as total_price
from (select s.customer_id,m.product_name,order_date,price
from sales s 
left join members mem on s.customer_id = mem.customer_id 
left join menu m on s.product_id=m.product_id
where order_date < join_date) as dd
group by customer_id;

# 9 - If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have? #

with with_point as (select s.customer_id, case
            when product_name = "sushi" then m.price * 20
            else m.price * 10
            end as customer_point
from sales s
left join menu m on s.product_id = m.product_id 
left join members mem on s.customer_id = mem.customer_id
where join_date is not null)

select customer_id , sum(customer_point) as total_point
from with_point
group by customer_id;

# 10 - In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January? #

with extra_points as (select s.customer_id,mem.join_date,s.order_date,m.product_name,m.price ,case 
																		when product_name = "curry" and order_date between join_date and join_date+6 then m.price * 20
																		when product_name = "ramen" and order_date between join_date and join_date+6 then m.price * 20
																		when product_name = "sushi" and month(order_date) = 1 then m.price * 20
																		when month(order_date) = 1 then m.price * 10
																		end as extra_points
from sales s 
left join members mem on s.customer_id=mem.customer_id
left join menu m on s.product_id=m.product_id)


select customer_id,sum(extra_points) as total_points 
from extra_points
where join_date is not null
group by customer_id;

## BONUS QUESTIONS ##

# 1 - Join All The Things #

select s.customer_id,s.order_date,m.product_name,m.price,case 
																when order_date >= join_date then "Y"
																else "N"
																end as "member"
from sales s 
left join menu m on s.product_id = m.product_id
left join members mem on s.customer_id = mem.customer_id;

# 2 - Rank All The Things #

with join_all as (select s.customer_id,s.order_date,m.product_name,m.price,case 
																when order_date >= join_date then "Y"
																else "N"
																end as "member"
from sales s 
left join menu m on s.product_id = m.product_id
left join members mem on s.customer_id = mem.customer_id)

select *, case 
			when member = "Y" then rank() over(partition by customer_id,member order by order_date) 
            end as ranking
from join_all;
