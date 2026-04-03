#Amazon Sales Analysis

#Q1-What is the total number of orders and total sales generated?
select SUM(Amount) AS total_revenue,
	   COUNT(*) AS total_orders
from amazon_sales_cleaned;

#Q2- What is the average order value ?
select SUM(Amount) / COUNT(*) AS average_order_value
FROM amazon_sales_cleaned;

#Q3- Which product categories generate the highest revenue?
select Category,ROUND(SUM(Amount),2) AS total_revenue
FROM amazon_sales_cleaned
group by Category;

#Q4-Which are the top 5 cities contributing the most to total sales?
select `ship-city`,ROUND(SUM(Amount),2) AS total_revenue
FROM amazon_sales_cleaned
group by `ship-city`
order by total_revenue DESC
LIMIT 5;

#Q5- Find order status count ?
select Status,COUNT(*) AS total_orders
from amazon_sales_cleaned
group by Status;

#Q6-What is the total revenue lost due to cancelled orders?
select SUM(Amount) AS revenue_loss
from amazon_sales_cleaned
WHERE Status = 'Cancelled'
;

#Q7-What is the overall cancellation rate of orders?
select
	ROUND(COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END),2) * 100 / COUNT(*) AS cancellation_rate
from amazon_sales_cleaned
;

#Q9- Which states contribute the most to overall revenue?
select `ship-state`,ROUND(SUM(Amount),2) AS total_revenue
from amazon_sales_cleaned
group by `ship-state`
order by total_revenue DESC
;

#Q10- Find Which categories generate high revenue but also have high cancellation rates?
select Category,ROUND(SUM(Amount),2) AS total_revenue,
       COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) * 100 / COUNT(*) AS cancellation_rate
from amazon_sales_cleaned
group by Category
order by cancellation_rate DESC
;

#Q11-Find top 3 city generates highest revenue per states?
select *
from (select `ship-state`,`ship-city`,ROUND(SUM(Amount),2) AS total_revenue,
      RANK() OVER(partition by `ship-state` order by SUM(Amount) DESC) AS rankk
      from amazon_sales_cleaned
      group by `ship-city`,`ship-state`)t
WHERE rankk <= 3     
;

#Q12-Find order value segmentation 
select
	case
		WHEN Amount < 500 then 'low value'
        WHEN Amount BETWEEN 500 AND 1000 THEN 'medium value'
        ELSE 'high value'
        END AS order_segmentation
from amazon_sales_cleaned
group by order_segmentation
;
