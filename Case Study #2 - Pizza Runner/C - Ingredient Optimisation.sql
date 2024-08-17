## C - Ingredient Optimisation ##

# 1 - What are the standard ingredients for each pizza? #

with sep_toppings as (select t.pizza_id, (j.topping)
from pizza_recipes t
join json_table(trim(replace(json_array(t.toppings), ',', '","')), '$[*]' columns (topping varchar(50) PATH '$')) j)

select p.topping_name,count(*) as num_of_toppings
from sep_toppings s
left join pizza_toppings p on s.topping = p.topping_id
group by p.topping_name
having num_of_toppings > 1;

# 2 - What was the most commonly added extra? #

with sep_extras as (select j.extras
from customer_orders_temp c
join json_table(trim(replace(json_array(extras), ',', '","')), '$[*]' columns (extras varchar(50) PATH '$')) j
where c.extras != "")

select topping_name, count(*) as num_extras 
from sep_extras s
left join pizza_toppings p on s.extras = p.topping_id
group by topping_name
order by num_extras DESC
limit 1;

# 3 - What was the most common exclusion? #

with sep_exclusions as (select j.exclusions 
from customer_orders_temp c
join json_table(trim(replace(json_array(exclusions),',','","')), '$[*]' columns (exclusions varchar(50) path "$" )) j
where c.exclusions != "")

select topping_name,count(*) as num_exclusions
from sep_exclusions s
left join pizza_toppings p on s.exclusions = p.topping_id
group by topping_name
order by num_exclusions desc
limit 1;