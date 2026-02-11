-- Change over Analysis by Month and Year

SELECT 
YEAR(order_date) AS Order_Year,
MONTH(order_date) AS Order_month,
SUM(sales_amount) AS Total_sales,
COUNT(DISTINCT customer_key) as Total_Customers,
SUM(quantity) as Total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)