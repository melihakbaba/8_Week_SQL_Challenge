## B - Data Analysis Questions ## 

# 1 - How many customers has Foodie-Fi ever had? #

select count(distinct customer_id) as num_of_customers
from subscriptions;

# 2 - What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value #

select monthname(start_date) as months,count(monthname(start_date)) as count_of_months  
from subscriptions
where plan_id = 0
group by  months
order by count_of_months desc;

# 3 - What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name #

select p.plan_name, count(*) as count_of_plans
from subscriptions s
left join plans p on s.plan_id = p.plan_id
where year(start_date) > 2020
group by p.plan_name;

# 4 - What is the customer count and percentage of customers who have churned rounded to 1 decimal place? #

select sum(case
			when plan_id = 4 then 1 else 0 end) as count_of_churn,round(sum(case
																			when plan_id = 4 then 1 else 0 end) / count(distinct customer_id),2) as prop_of_churn
from subscriptions;

# 5 - How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number? #

create temporary table leaded_plan as (select * ,lead(plan_id,1) over(partition by customer_id order by plan_id) as next_plan
from subscriptions);

select count(next_plan) as count_of_churn_free from leaded_plan
where plan_id = 0 and next_plan = 4;

# 6 - What is the number and percentage of customer plans after their initial free trial? #

select p.plan_name,count(*) as count_of_plans , count(*) / (select count(distinct customer_id) from subscriptions) as prop_of_plans
from leaded_plan l 
left join plans p on l.next_plan = p.plan_id
where next_plan is not null and l.plan_id = 0
group by p.plan_name;

# 7 - What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31? #

with ranked_plans as (select p.plan_name, row_number() over(partition by customer_id order by s.plan_id desc) as queue
from subscriptions s
left join plans p on s.plan_id = p.plan_id
where date(start_date) < '2020-12-31')

select plan_name,count(*) as count_of_plans, count(*) / (select count(distinct customer_id) from subscriptions where date(start_date) < '2020-12-31') as prop_of_plans
from ranked_plans
where queue = 1
group by plan_name;

# 8 - How many customers have upgraded to an annual plan in 2020? #

select count(*) as count_of_upg_annual_plan
from leaded_plan 
where year(start_date) = "2020" and next_plan=3;

# 9 - How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi? #

create temporary table annual_plan as (select * 
from subscriptions
where plan_id = 3);

select round(avg(timestampdiff(day,s.start_date,a.start_date))) as avg_day_to_annual_plan
from subscriptions s
inner join annual_plan a on s.customer_id = a.customer_id
where s.plan_id = 0;

# 10 - Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc) #

create temporary table days as (select timestampdiff(day,s.start_date,a.start_date) as day_to_annual_plan
from subscriptions s
inner join annual_plan a on s.customer_id = a.customer_id
where s.plan_id = 0);

with divided_days as (select (case
		when day_to_annual_plan between 0 and 30 then "0-30 day"
        when day_to_annual_plan between 31 and 60 then "31-60 day"
        when day_to_annual_plan between 61 and 90 then "61-90 day"
        when day_to_annual_plan between 91 and 120 then "91-120 day"
        when day_to_annual_plan between 121 and 150 then "121-150 day"
        when day_to_annual_plan > 151 then "more than 151 days"
        end)  as days
 from days)
 
 select days,count(*) as count_of_days
 from divided_days
 group by days;

# 11 - How many customers downgraded from a pro monthly to a basic monthly plan in 2020? #
drop table if exists downgraded_plan;
create temporary table downgraded_plan as (select *,lead(plan_id) over(partition by customer_id order by start_date) as next_plan
from subscriptions
where year(start_date) = "2020");

select count(*) count_of_downgraded
from downgraded_plan
where plan_id = 2 and next_plan = 1 ;

