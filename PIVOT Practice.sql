--1.
--Create a state wise report showing all states along with their total sales
--which are better than overall national average

with cte1 as(
select l.state,sum(t.sales_amount) as Total_sales
from ex_transactions t
join ex_orders o on t.Order_ID=o.order_id
join ex_customers c on o.customer_id=c.customer_id
join ex_locations l on c.postal_code=l.postal_code
group by l.state
)
select * from cte1
--The national average will be the average of the Total Sales columns
where Total_sales>(select avg(Total_sales) as national_avg from cte1)

--2.
--you have been asked to create a state-wise report of top 3 cities by sales,
--which will be used by the Sales Leadership to identify high-performing territories
--and reward Area Sales Managers accordingly.

--Presents the results in a clear tabular format with each row representing a state and
--columns for Rank 1, Rank 2, and Rank 3 cities.(Using PIVOT)
with city_sales as (
select l.state,l.city,sum(t.sales_amount) as Total_sales
from ex_transactions t
join ex_orders o on t.Order_ID=o.order_id
join ex_customers c on o.customer_id=c.customer_id
join ex_locations l on c.postal_code=l.postal_code
group by l.state,l.city
),
ranked as (
select state,city,Total_sales,
rank() over(partition by state order by Total_sales desc) as rank_in_state
from city_sales
)
select state,
[1] as Rank_1,
[2] as Rank_2,
[3] as Rank_3
from ranked
pivot (
max(city)
for rank_in_state in ([1], [2], [3])
) as p
order by state;

--3.
--Need to calculate Sachin's Month-To-Date (MTD) runs. This will track how his runs accumulated within each month, 
--match-by-match, giving a clear view of his consistency in shorter time frames.

-- Step 1: Convert date and select required columns
with sachin_data as (
select seq_no,cast(mtch_date as date) as match_date,versus,venue,dismissal_mode,runs
from sachin_scores
)
-- Step 2: Calculate Month-To-Date (MTD) runs
select seq_no, match_date,versus,venue, dismissal_mode,
datepart(year, match_date) as match_year,
datepart(month, match_date) as match_month,
datepart(day, match_date) as match_day,runs,
-- Running total of runs within the same month
sum(runs) over (partition by datepart(year, match_date),datepart(month, match_date) order by match_date
    ) as mtd_runs
from sachin_data

order by match_date;
