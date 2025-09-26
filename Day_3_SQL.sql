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