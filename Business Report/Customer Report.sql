/* Customer Report

Purpose: This Report consoidates key customer metrics and behaviors
Highlights
1. Gathers essential fields such as names,ages and transaction details.
2. Segments customers into categories (VIP,Regular, New) and Age Groups.
3. Aggregates customer- Level Metrics:
- Total orders
- Total Sales
- Total quantity Puchased
- Total Products
- Lifespan (in months)
4. Calculates valuable KPIs
- recency (months since last order)
- average order value
- average monthly spend
*/
CREATE VIEW Gold.report_customers AS
WITH Customer_Table AS(
/* Creating a base Table with Requried details from different tables using joins*/
SELECT
F.order_date,
F.order_number,
F.product_key,
F.quantity,
F.sales_amount,
C.customer_number,
C.customer_key,
CONCAT(C.first_name, ' ',C.last_name) as Customer_Name,
DATEDIFF(YEAR,C.birthdate, GETDATE()) AS Age
 FROM gold.fact_sales AS F
LEFT JOIN gold.dim_customers AS C
ON C.customer_key =f.customer_key
WHERE order_date IS NOT NULL)
/* Below CTE as for Aggregration from the Above CTE */
,Customer_Aggre AS(
SELECT 
customer_number,
customer_key,
Customer_Name,
Age,
COUNT(DISTINCT order_number) AS Total_Orders,
SUM(sales_amount) AS Total_sales,
SUM(quantity) AS Total_quantity,
COUNT( DISTINCT product_key) AS Total_Product,
MAX(Order_date) AS last_Order,
MIN(Order_date) AS First_order,
DATEDIFF(MONTH, MIN(Order_date), MAX(Order_date)) AS Lifespan
FROM Customer_Table
GROUP BY 
	customer_number,
	customer_key,
	Customer_Name,
	Age
)
SELECT
customer_number,
customer_key,
Customer_Name,
Age,
CASE 
WHEN Age <20 THEN 'Teenage'
WHEN Age BETWEEN 20 AND 40 THEN 'Adult'
WHEN Age BETWEEN 40 AND 60 THEN 'Elder'
ELSE 'Old'
END Age_Group,
CASE 
	WHEN Lifespan >= 12 AND Total_sales >5000 THEN 'VIP'
	WHEN Lifespan >= 12 AND Total_sales <=5000 THEN 'Regular'
	ELSE 'New'
END AS Customer_segment,
last_Order,
DATEDIFF(MONTH, Last_order, GETDATE()) AS Recency,
Total_orders,
Total_sales,
Total_quantity,
Total_Product,
Lifespan,
-- Compute Average order value
CASE 
	WHEN Total_Orders =0  THEN 0
	ELSE Total_sales/Total_orders
END AS Avg_order_value,
-- Compute Average Monthly Spend
CASE 
	WHEN lifespan =0 THEN Total_sales
	ELSE Total_sales/ Lifespan
END AS Average_Monthly_spend
FROM Customer_Aggre

