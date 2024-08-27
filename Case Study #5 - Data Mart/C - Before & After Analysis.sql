
## C - Before & After Analysis ##

# 1 - What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales? #

with before_four_week as (select (case 
						when t_week_date between date_sub("2020-06-15",interval 4 week) and "2020-06-15" then "Before"
                        else null end ) as four_week_before , sum(sales) as total_sales_before
from cleaned_week_sales
where t_week_date between date_sub("2020-06-15",interval 4 week) and "2020-06-15" 
group by four_week_before),
after_four_week as (select  (case 
						when t_week_date between "2020-06-15" and date_add("2020-06-15",interval 4 week) then "After"
                        else null end ) as four_week_after , sum(sales) as total_sales_after
from cleaned_week_sales
where t_week_date between "2020-06-15" and date_add("2020-06-15",interval 4 week)
group by four_week_after)

select 
total_sales_before,
total_sales_after, 
(total_sales_after-total_sales_before) as change_of_sales , 
(total_sales_after-total_sales_before)/total_sales_before as percentage_change
from before_four_week,after_four_week;


# 2 - What about the entire 12 weeks before and after? #

with before_twelve_week as (select (case 
						when t_week_date between date_sub("2020-06-15",interval 12 week) and "2020-06-15" then "Before"
                        else null end ) as twelve_week_before , sum(sales) as total_sales_before
from cleaned_week_sales
where t_week_date between date_sub("2020-06-15",interval 12 week) and "2020-06-15" 
group by twelve_week_before),
after_twelve_week as (select  (case 
						when t_week_date between "2020-06-15" and date_add("2020-06-15",interval 12 week) then "After"
                        else null end ) as twelve_week_after , sum(sales) as total_sales_after
from cleaned_week_sales
where t_week_date between "2020-06-15" and date_add("2020-06-15",interval 12 week)
group by twelve_week_after)

select 
total_sales_before,
total_sales_after, 
(total_sales_after-total_sales_before) as change_of_sales , 
(total_sales_after-total_sales_before)/total_sales_before as percentage_change
from before_twelve_week,after_twelve_week;

# 3 - How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019? #
