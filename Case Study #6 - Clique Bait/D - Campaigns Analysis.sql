
## D - Campaigns Analysis ## 

with lister as (select visit_id,group_concat(page_name order by event_time asc separator ",") as cart_products
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
where e.page_id not in (1,2,12,13) and event_type = 2	
group by e.visit_id)

select u.user_id,
	   e.visit_id,
       min(event_time) as visit_start_time,
       sum(case when event_type = 1 then 1 else 0 end) as page_views,
       sum(case when event_type = 2 then 1 else 0 end) as cart_adds,
       sum(case when event_type = 3 then 1 else 0 end) as purchase,
       ci.campaign_name,
       sum(case when event_type = 4 then 1 else 0 end) as impression,
       sum(case when event_type = 5 then 1 else 0 end) as click,
       cart_products
from events e
left join users u on e.cookie_id = u.cookie_id
left join campaign_identifier ci on e.event_time between ci.start_date and ci.end_date
left join lister l on l.visit_id = e.visit_id
group by u.user_id,e.visit_id,ci.campaign_name,l.cart_products;

