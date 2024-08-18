## A - Customer Journey ##

select customer_id,p.plan_name,start_date 
from subscriptions s
left join plans p on s.plan_id = p.plan_id
where customer_id <= 8;

# Customer_1, Customer_3, and Customer_5 started with a 1-week trial, then canceled and switched to a basic monthly subscription.
# Customer_2 started with a 1-week trial, then switched to an annual pro subscription.
# Customer_4 started with a 1-week trial, then canceled and switched to a basic monthly subscription. After 3 months, they canceled their subscription.
# Customer_6 started with a 1-week trial, then canceled and switched to a basic monthly subscription. After 2 months, they canceled their subscription.
# Customer_7 switched to a basic monthly subscription after the 1-week trial. After 3 months, they upgraded their subscription to pro.
# Customer_8 switched to a basic monthly subscription after the 1-week trial. After 2 months, they upgraded their subscription to pro.