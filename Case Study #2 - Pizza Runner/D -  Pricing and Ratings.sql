## D -  Pricing and Ratings ##

# 1 - If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - 
--     how much money has Pizza Runner made so far if there are no delivery fees? #

select sum(case 
			when pizza_name = "Vegetarian" then 10
            else 12
            end) as total_income 
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
left join pizza_names p on c.pizza_id = p.pizza_id
where duration != " ";


# 2 - What if there was an additional $1 charge for any pizza extras?
--    Add cheese is $1 extra #

with extra_pizzas as (select pizza_name,length(replace(extras, ", ", "")) as num_extras
from customer_orders_temp c
left join runner_orders_temp r on c.order_id = r.order_id
left join pizza_names p on c.pizza_id = p.pizza_id
where duration != " ")

select sum(case 
			when pizza_name = "Vegetarian"  then 10 + num_extras
            else 12 + num_extras
            end) as total_income 
from extra_pizzas;

# 3 - The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5. #

drop table if exists runner_ratings;
create table runner_ratings (
runner_id int,
order_id int,
rating int
);

insert into runner_ratings (runner_id,order_id,rating)
values 
(1,1,3),
(1,2,4),
(1,3,2),
(2,4,1),
(3,5,5),
(2,7,2),
(2,8,5),
(1,10,5);

select * from runner_ratings;

# 4 - Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas

select rr.runner_id,rr.order_id,c.customer_id,rr.rating,c.order_time,r.pickup_time,timestampdiff(minute,c.order_time,r.pickup_time) as prepare_time,
r.duration,round((distance / duration) * 60,2) as avg_speed, count(*) over(partition by rr.order_id) as count_of_pizza
from runner_ratings rr
left join customer_orders_temp c on rr.order_id = c.order_id
left join runner_orders_temp r on rr.order_id = r.order_id;

# 5 - If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - 
-- how much money does Pizza Runner have left over after these deliveries? #

create temporary table income as (select sum(case 
			when pizza_id = 2 then 10 else 12 end) as income_from_pizzas
from customer_orders_temp 
left join runner_orders_temp using(order_id)
where duration != " ");

create temporary table outcome as (
select sum(distance * 0.30) as paid_runner  
from runner_orders_temp 
where duration != " " ); 

select income_from_pizzas - paid_runner as profit
from income,outcome;

