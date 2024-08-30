
## C - Product Funnel Analysis ##

# 	1 - Using a single SQL query - create a new output table which has the following details:
-- How many times was each product viewed?
-- How many times was each product added to cart?
-- How many times was each product added to a cart but not purchased (abandoned)?
-- How many times was each product purchased?

drop table if exists products;
create temporary table products as (

with purchased_visits as (select visit_id
	from events
	where event_type = 3),
    
purchased as (select e.page_id,ph.page_name , sum(case
						when event_type = 2 then 1
                        else 0 end) as n_purchased
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
inner join purchased_visits p  on e.visit_id = p.visit_id
where e.page_id not in (1,2,12,13)
group by e.page_id,ph.page_name),

viewed_addedcart as (select ph.page_name,sum(case
						when e.event_type = 1 then 1
                        else 0 end) as n_viewed,
					sum(case
						when e.event_type = 2 then 1
                        else 0 end) as n_added_to_cart
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
where e.page_id not in (1,2,12,13)
group by ph.page_name),
    
abandoned as (select e.page_id,ph.page_name , sum(case
						when event_type = 2 then 1
                        else 0 end) as n_abandoned
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
where e.page_id not in (1,2,12,13) and not exists(select ev.visit_id from events ev where event_type = 3 and e.visit_id = ev.visit_id)
group by e.page_id,ph.page_name)


select distinct v.page_name,n_viewed,n_added_to_cart,a.n_abandoned,p.n_purchased
from viewed_addedcart v
left join purchased p on v.page_name = p.page_name
left join abandoned a on v.page_name = a.page_name);

select * from products;

# 2 - Use your 2 new output tables - answer the following questions:

# 2.1 - Which product had the most views, cart adds and purchases?

with ranked as (select page_name,rank() over(order by n_viewed desc) as most_viewed,
rank() over(order by n_added_to_cart desc) as most_added_to_cart,
rank() over(order by n_purchased desc) as most_purchased
from products)
select case 
        when most_viewed = 1 then 'Most Viewed'
        when most_added_to_cart = 1 then 'Most Added'
        when most_purchased = 1 then 'Most Purchased'
    end as product,
    page_name
from ranked
where most_viewed = 1 or most_added_to_cart = 1 or most_purchased = 1;

# 2.2 Which product was most likely to be abandoned?

select  page_name,
		n_abandoned,
		rank() over(order by n_abandoned desc) as rank_of_abandoned
from products
order by rank_of_abandoned asc
limit 1;

# 2.3 Which product had the highest view to purchase percentage?

select page_name,
		(n_purchased / n_viewed) as ratio_of_purchase
from products
order by ratio_of_purchase desc
limit 1;

# 2.4 What is the average conversion rate from view to cart add?

select sum(n_added_to_cart) / sum(n_viewed) as avg_view_to_cart
from products;

# 2.5 What is the average conversion rate from cart add to purchase?

select sum(n_purchased) / sum(n_added_to_cart) as avg_cart_to_purchase
from products;