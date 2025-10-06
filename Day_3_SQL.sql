--Problem Statement:You need to create a report of states whose total sales are greater than the national average.

-- Calculating state wise Total_sales.
select l.state,sum(t.sales) as Total_sales from locations_01 l
join customers c on l.postal_code=c.postal_code
join orders o on c.customer_id=o.customer_id
join transactions t on o.order_id=t.Order_ID
group by l.state
order by l.state;

--Calculating state wise average of total_sales. 
select l.state,avg(t.sales) as Avg_sales from locations_01 l
join customers c on l.postal_code=c.postal_code
join orders o on c.customer_id=o.customer_id
join transactions t on o.order_id=t.Order_ID
group by l.state
order by l.state;

--Joing both the logics and using 1 sub query, calculating total sales are greater than the national average.

select state,Total_sales
from (select l.state,
           sum(t.sales) as Total_sales,
           avg(sum(t.sales)) over () as avg_sales
    from locations_01 l
    join customers c on l.postal_code = c.postal_code
    join orders o    on c.customer_id = o.customer_id
    join transactions t on o.order_id = t.Order_ID
    group by l.state
) as state_totals
where Total_sales > avg_sales

order by state;

--GlobalMart Sales team would like to perform geographical analysis of sales across the 4 regions : East, South, West and Central.
select l.region,l.state,sum(t.Sales_amount) as Sales,
sum(sum(t.Sales_amount)) over(partition by l.region) as region_sales,
sum(sum(t.sales_amount)) over() as Overall_Sales,
sum(t.Sales_amount) * 100.0/ sum(sum(t.sales_amount)) over (partition by l.region) as Contribution_Percent,
sum(t.Sales_amount) * 100.0/ sum(sum(t.sales_amount)) over () as Overall_Contribution
from ex_locations l
join ex_customers c on l.postal_code=c.postal_code
join ex_orders o on c.customer_id=o.customer_id
join ex_transactions t on o.order_id=t.Order_ID
group by l.region,l.state
order by l.region,l.state;
