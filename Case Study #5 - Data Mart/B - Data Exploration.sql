
## B - Data Exploration ##

# 1 - What day of the week is used for each week_date value? #

select distinct dayname(t_week_date) as day_name 
from cleaned_week_sales;

# 2 - What range of week numbers are missing from the dataset? #

with recursive week_numbers as (
    select 1 as all_week_numbers
    union all
    select all_week_numbers + 1
    from week_numbers
    where all_week_numbers < 52)

select distinct all_week_numbers
from week_numbers w
left join cleaned_week_sales c on w.all_week_numbers = c.week_number
where c.week_number is null
order by all_week_numbers;

# 3 - How many total transactions were there for each year in the dataset? #

select calendar_year,sum(transactions) as total_transactions
from cleaned_week_sales
group by calendar_year;

# 4 - What is the total sales for each region for each month? #

select region,month_number,sum(sales) as total_sales 
from cleaned_week_sales
group by region,month_number;

# 5 - What is the total count of transactions for each platform? #

select platform,sum(transactions) as total_transactions
from cleaned_week_sales
group by platform;

# 6 - What is the percentage of sales for Retail vs Shopify for each month? #

with sales as (select month_number,platform, sum(sales) as total_sales 
from cleaned_week_sales
group by month_number,platform),
month_sales as (select * , sum(total_sales) over(partition by month_number) as month_sales
from sales)

select month_number,platform,(total_sales / month_sales) as percentage_of_sales
from month_sales;

# 7 - What is the percentage of sales by demographic for each year in the dataset? #

with sales as (select calendar_year,demographic,sum(sales) as total_sales 
from cleaned_week_sales
group by calendar_year,demographic),
demog_sales as (select *,sum(total_sales) over(partition by calendar_year) as year_sales
from sales)

select calendar_year,demographic, (total_sales / year_sales) as percentage_of_sales
from demog_sales;

# 8 - Which age_band and demographic values contribute the most to Retail sales? #

select age_band, demographic,sum(sales) as total_sales , (sum(sales)/ sum(sum(sales)) over()) AS percentage_of_sales
from cleaned_week_sales
where platform = "Retail" 
group by age_band,demographic
order by percentage_of_sales desc;

# 9 - Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead? #

select calendar_year,platform, 
avg(avg_transaction) as avg_avg_transaction,
sum(sales)/ sum(transactions) as avg_transaction
from cleaned_week_sales
group by calendar_year,platform;

-- When the avg_transaction column was created, it already calculated the average transaction. 
-- Taking the average of an average to find the transaction size by year would be misleading. 

