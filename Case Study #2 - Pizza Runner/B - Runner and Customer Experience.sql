## B - Runner and Customer Experience ## 

# 1 - How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01) #

select week(registration_date,1) as reg_week, count(runner_id) as signed_runner
from runners
group by reg_week;

# 2 - What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order? # 

with time_diff_runner as (select distinct c.order_id, r.runner_id,timestampdiff(minute,order_time,pickup_time) as time_diff
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id 
where duration != " "
)

select runner_id, avg(time_diff) as avg_arrive
from time_diff_runner
where time_diff > 0
group by runner_id;

# 3 - Is there any relationship between the number of pizzas and how long the order takes to prepare? #

with num_pizza_prepare as (select c.order_id,count(c.pizza_id) as count_of_pizza ,timestampdiff(minute,order_time,pickup_time) as prepare_time
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id 
where duration != " "
group by c.order_id,prepare_time)

select count_of_pizza, avg(prepare_time) as avg_prepare_time
from num_pizza_prepare
group by count_of_pizza;

# 4 - What was the average distance travelled for each customer? #

select customer_id , round(avg(distance),2) as avg_distance from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
where distance != ""
group by customer_id;

# 5 - What was the difference between the longest and shortest delivery times for all orders? #

select (max(duration)-min(duration)) as diff_del_time from runner_orders_temp
where distance != "";

# 6 - What was the average speed for each runner for each delivery and do you notice any trend for these values? # 

select runner_id,order_id,distance,duration,round((distance / duration) * 60,2) as avg_speed 
from runner_orders_temp
where duration != " ";

# 7 - What is the successful delivery percentage for each runner? # 

select runner_id,round(sum(case
		 when duration != " " then 1 
         else 0
         end) / count(order_id),2 ) as success_prop
from runner_orders_temp
group by runner_id;
