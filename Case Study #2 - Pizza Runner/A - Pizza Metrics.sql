## A - PIZZA  METRICS ##

# 1 - How many pizzas were ordered? # 

select count(*) as order_count 
from customer_orders_temp;

# 2 - How many unique customer orders were made? #

select count(distinct order_id) as countof_unique_orders 
from customer_orders_temp;

# 3 - How many successful orders were delivered by each runner? # 

select runner_id,count(duration) as successful_orders 
from runner_orders_temp 
where duration != " " 
group by runner_id;

# 4 - How many of each type of pizza was delivered? #

select pizza_name, count(*) type_count 
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
left join pizza_names pn on c.pizza_id = pn.pizza_id
where duration != " "
group by pizza_name;

# 5 - How many Vegetarian and Meatlovers were ordered by each customer? #

select customer_id,pizza_name, count(*) as order_count 
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
left join pizza_names pn on c.pizza_id = pn.pizza_id
group by customer_id,pizza_name
order by customer_id;

# 6 - What was the maximum number of pizzas delivered in a single order? # 

select order_id,count(order_id) as max_pizza 
from customer_orders_temp
group by order_id
order by max_pizza desc
limit 1;

# 7 - For each customer, how many delivered pizzas had at least 1 change and how many had no changes? #

select c.customer_id,sum(case 
						when exclusions != "" or extras != "" then 1 
                        else 0
                        end) at_least_1changes, 
                        sum(case 
						when exclusions = "" and  extras = "" then 1
                        else 0 
                        end)  as no_changes 
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
where duration != " "
group by customer_id;

# 8 - How many pizzas were delivered that had both exclusions and extras? #

select sum(case 
			when c.exclusions != "" and c.extras != "" then 1 
            else 0 
            end) as both_change from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
where duration != " " ;

# 9 - What was the total volume of pizzas ordered for each hour of the day? #

select hour(order_time) as hourly , count(order_id) as ordered
from customer_orders_temp
group by hourly
order by hourly asc;

# 10 - What was the volume of orders for each day of the week? # 

select dayname(order_time) as day_of_week, count(order_id) as ordered
from customer_orders_temp 
group by day_of_week;

