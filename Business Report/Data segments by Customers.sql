/* Group Customers into Segments based on their spending Behaviour
- VIP: Customers with at least 12 months of history and spending more than 5000,
- Regular: Customers with  at least 12 months of history but spending 5000 or less,
-New: Customers  with lifespan less than 12 months.
 and Find the total number of customer by each Group*/

WITH Customer_Segments AS(
 SELECT 
 C.Customer_key,
 SUM(F.Sales_amount) AS Total_sales,
 MIN(order_date) AS First_order,
 MAX(order_date) AS Last_order,
 DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS Customer_Period
 FROM Gold.fact_sales AS F
 LEFT JOIN gold.dim_customers AS C
 ON F.customer_key= C.customer_key
 GROUP BY c.customer_key)
 ,Customer_Grouping AS(
 SELECT
 Customer_key,
 Customer_Period,
 Total_sales,
 CASE WHEN Customer_Period >=12 AND Total_sales >5000 THEN 'VIP'
	  WHEN Customer_Period >=12 AND Total_sales <=5000 THEN 'Regular'
	  ELSE 'New'
 END Customer_Group
 FROM Customer_Segments)
 SELECT 
 Customer_Group,
 COUNT(Customer_key) AS Total_Customer
 FROM Customer_Grouping
 GROUP BY Customer_Group

 
 