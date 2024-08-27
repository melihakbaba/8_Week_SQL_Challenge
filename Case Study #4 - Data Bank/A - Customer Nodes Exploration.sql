## A - Customer Nodes Exploration ##

# 1 - How many unique nodes are there on the Data Bank system? #

select count(distinct node_id) as unique_nodes
from customer_nodes;

# 2 - What is the number of nodes per region? #

select r.region_name , count(node_id) as nodes
from customer_nodes c
left join regions r on c.region_id = r.region_id
group by r.region_name;

# 3 - How many customers are allocated to each region? #

select region_name, count(distinct c.customer_id) as num_of_customers 
from customer_nodes c
left join regions r on c.region_id = r.region_id
group by region_name;

# 4 - How many days on average are customers reallocated to a different node? #

select avg(timestampdiff(day,start_date,end_date)) as avg_change 
from customer_nodes
where year(end_date) != 9999;

# 5 - What is the median, 80th and 95th percentile for this same reallocation days metric for each region? #

create temporary table days (select region_name,timestampdiff(day,start_date,end_date) as reallocation_days 
from customer_nodes c
left join regions r on c.region_id = r.region_id
where year(end_date) != 9999);

create temporary table percentile_days as (select *,percent_rank() over(partition by region_name order by reallocation_days ) * 100 as percentiles
from days);


# for median

with ranked_percentiles as (select region_name,reallocation_days ,row_number() over(partition by region_name order by reallocation_days) as row_id,percentiles
from percentile_days
where percentiles > 50)

select region_name,reallocation_days
from ranked_percentiles
where row_id = 1;

# for 80th 

with ranked_percentiles as (select region_name,reallocation_days ,row_number() over(partition by region_name order by reallocation_days) as row_id,percentiles
from percentile_days
where percentiles > 80)

select region_name,reallocation_days
from ranked_percentiles
where row_id = 1;

# for 95th 

with ranked_percentiles as (select region_name,reallocation_days ,row_number() over(partition by region_name order by reallocation_days) as row_id,percentiles
from percentile_days
where percentiles > 95)

select region_name,reallocation_days
from ranked_percentiles
where row_id = 1;
