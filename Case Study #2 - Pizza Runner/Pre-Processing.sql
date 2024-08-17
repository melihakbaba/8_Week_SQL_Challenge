## Pre-Processing ## 

# 1 - for customer_orders table
drop table if exists customer_orders_temp;
create temporary table customer_orders_temp as
select 
  order_id, 
  customer_id, 
  pizza_id, 
  case
	  when exclusions is null or exclusions like 'null' then ""
	  else exclusions
	  end as exclusions,
  case
	  when extras is null or extras like 'null' then ""
	  else extras
	  end as extras,
	order_time
from customer_orders;

# 2 - for runner_orders table
drop table if exists runner_orders_temp;
create temporary table runner_orders_temp as
select 
  order_id, 
  runner_id,  
  case
	  when pickup_time like 'null' then ""
	  else pickup_time
	  end as pickup_time,
  case
	  when distance like 'null' then ""
	  when distance like '%km' then TRIM('km' from distance)
	  else distance 
    end as distance,
  case
	  when duration like 'null' then ' '
	  when duration like '%mins' then TRIM('mins' from duration)
	  when duration like '%minute' then TRIM('minute' from duration)
	  when duration like '%minutes' then TRIM('minutes' from duration)
	  else duration
	  end as duration,
  case
	  when cancellation is null or cancellation like 'null' then ""
	  else cancellation
	  end as cancellation
from runner_orders;

# 3 - data types

alter table runner_orders_temp
modify column pickup_time datetime,
modify column distance float,
modify column duration int;