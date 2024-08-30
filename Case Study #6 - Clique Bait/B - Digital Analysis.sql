
## B - Digital Analysis ##

# 1 - How many users are there? #

select count(distinct user_id) as user_number 
from users;

# 2 - How many cookies does each user have on average? #

with n_cookie as (select user_id,count(cookie_id) as count_of_cookies
from users
group by user_id)

select avg(count_of_cookies) as avg_number_cookie
from n_cookie;

# 3 - What is the unique number of visits by all users per month? #

select monthname(event_time) as months , count(distinct visit_id) as count_of_visits
from events
group by monthname(event_time);

# 4 - What is the number of events for each event type? #

select ei.event_name , count(ei.event_name) as count_of_events
from events e
left join event_identifier ei on e.event_type = ei.event_type
group by ei.event_name;

# 5 - What is the percentage of visits which have a purchase event? #

select "Purchase" as event_name,
		sum(case 
			when event_type = 3 then 1 
            else 0 end)  / count(distinct visit_id) as percentage_of_purchase
            
from events;

# 6 - What is the percentage of visits which view the checkout page but do not have a purchase event? #

with check_purchase as (select visit_id,sum(case 
					when page_id = 12 and event_type = 1 then 1 
                    else 0 end) as checkout , 
				sum(case 
					when event_type = 3 then 1
                    else 0 end) as purchased
from events
group by visit_id)

select "Checkout" as page_name,
1-(sum(purchased) / sum(checkout)) as percentage_of_checkout
from check_purchase;

# 7 - What are the top 3 pages by number of views? #

select ph.page_name, count(ph.page_name) as n_page
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
where event_type = 1
group by ph.page_name
order by n_page desc
limit 3;

# 8 - What is the number of views and cart adds for each product category? #

select ph.product_category,sum(case 
					when event_type = 1 then 1
                    else 0 end) as count_of_views,
				sum(case
					when event_type = 2 then 1
                    else 0 end) as count_of_addtocart
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
where e.page_id not in (1,2,12,13)
group by ph.product_category;

# 9 - What are the top 3 products by purchases? #

with purchased as (select visit_id
	from events
	where event_type = 3)

select ph.page_name , sum(case
						when event_type = 2 then 1
                        else 0 end) as number_of_purchased
from events e
left join page_hierarchy ph on e.page_id = ph.page_id
inner join purchased p  on e.visit_id = p.visit_id
where e.page_id not in (1,2,12,13)
group by ph.page_name
order by number_of_purchased desc
limit 3;

