
## A - Data Cleansing Steps  ##

drop table if exists cleaned_week_sales;
create table cleaned_week_sales
with week_date_transformed as (select *,str_to_date(week_date,"%d/%m/%y") as  t_week_date 
from weekly_sales) 

select t_week_date, 
extract(week from t_week_date) as week_number,
extract(month from t_week_date) as month_number, 
year(t_week_date) as calendar_year,
segment,
case 
when right(segment,1) = "1" then "Young Adults"
when right(segment,1) = "2" then "Middle Aged"
when right(segment,1) in ("3","4") then "Retirees"
else "unknown" end as age_band,
case 
when left(segment,1) = "C" then "Couples"
when left(segment,1) = "F" then "Families"
else "unknown" end as demographic,
(sales/transactions) as avg_transaction,
region,
platform,
customer_type,
transactions,
sales
from week_date_transformed;

ALTER TABLE cleaned_week_sales 
CHANGE COLUMN segment segment VARCHAR(7);

update cleaned_week_sales
set segment = "unknown"
where segment = "null";

select * from cleaned_week_sales;
