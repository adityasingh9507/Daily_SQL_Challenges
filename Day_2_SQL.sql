--Report 1 : Prepare a Purchase Year, Month wise report of Sales

select year(o.order_purchase_date) as purchase_year,
month(o.order_purchase_date) as purchase_month,
sum(t.sales) as total_sales
from transactions t
join orders o on t.Order_ID = o.order_id
group by year(o.order_purchase_date), month(o.order_purchase_date)
order by purchase_year, purchase_month;


--Based on the output of Report-1, answer the questions that follow:
--In the year 2017, which purchase month recorded the highest sales? = November.
--The total sales in the month of March 2018 is ________? = 205397.8|(205366.75).


--Report 2 : Prepare a report to show top 5 Region-Category by most profits
select top 5 l.region,p.category,sum(t.profit) as total_profit
from transactions t
join orders o on t.order_id = o.order_id
join customers c on o.customer_id = c.customer_id
join locations_01 l on c.postal_code = l.postal_code
join products p on t.product_id = p.product_id
group by l.region, p.category
order by total_profit desc;

--Based on the output of Report-2, answer the questions that follow:
--Which region has the highest overall profit? = West.
--Which category has the highest overall profit across all regions? = Office Supplies.