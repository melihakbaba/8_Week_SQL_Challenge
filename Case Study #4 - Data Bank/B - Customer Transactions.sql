## B - Customer Transactions ##

# 1 - What is the unique count and total amount for each transaction type? #

select txn_type, count(txn_type) as count_of_types , sum(txn_amount) as total_amount
from customer_transactions
group by txn_type;

# 2 - What is the average total historical deposit counts and amounts for all customers? # 

with sum_depo as ( select customer_id,count(txn_type) as count_of_deposite,avg(txn_amount) as sum_amount
from customer_transactions
where txn_type = "deposit"
group by customer_id)

select round(avg(count_of_deposite))as num_avg_deposite,round(avg(sum_amount)) as avg_amount
from sum_depo;

# 3 - For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month? #

with count_transaction as (
  select customer_id, month(txn_date) as months, 
	sum(case when txn_type = 'deposit' then 1 else 0 end) as deposit_count,
    sum(case when txn_type = 'purchase' then 1 else 0 end) as purchase_count,
    sum(case when txn_type = 'withdrawal' then 1 else 0 end) as withdrawal_count
  from customer_transactions
  group by customer_id, month(txn_date)
)

select months, count(customer_id) as count_of_customer
from count_transaction
where deposit_count > 1 and (purchase_count >= 1 or withdrawal_count >= 1)
group by months;

# 4 - What is the closing balance for each customer at the end of the month? #

create temporary table amounts as (select customer_id ,month(txn_date) as month,
	sum(case when txn_type = "deposit" then txn_amount
		  when txn_type != "deposit" then -txn_amount
         end) as net_transaction
from customer_transactions
group by customer_id,month(txn_date));

select *,sum(net_transaction) over(partition by customer_id order by month) as net_balance
from amounts;

# 5 - What is the percentage of customers who increase their closing balance by more than 5%? #

with net_balance as (select *,sum(net_transaction) over(partition by customer_id order by month) as net_balance
from amounts),
next_balanced as (
select *,lead(net_balance) over(partition by customer_id order by month) as next_balance
from net_balance)

select sum(case 
				when ((next_balance - net_balance) / net_balance ) > 0.05 then 1
                else 0 end) / (select count(customer_id) from customer_transactions) * 100 as increase_more_than_5
from next_balanced
;

