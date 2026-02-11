/* 
                                        ========================================
                                                     Product Report
                                        ========================================
Purpose:
- This report consolidates key product metrics and behaviours

Highlights:
1. Gather essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identity High performers, Midrange or Low- Performers.
3. Aggregates Product- Level Metrics:
-Total Orders
- Total Sales
- Total quantity sold
- Total customers(unique)
- Lifespan(Months)
4. Calculates Valuable KPI,
- Recency (Months since Last sale)
- Average order revenue(AOR)
- Average Monthly revenue
*/
/* Base query to retrive the data from Tables*/
CREATE VIEW Gold.Product_Report AS
WITH Product_table AS(
SELECT
F.order_number,
F.order_date,
F.customer_key,
F.sales_amount,
F.quantity,
P.product_key,
P.product_name,
P.Category,
P.Subcategory,
P.Cost
FROM GOLD.fact_sales AS F
LEFT JOIN gold.dim_products AS P
ON F.product_key = p.product_key
WHERE order_date IS NOT NULL)
,Product_Aggregate AS(
-- Products Aggreations for above CTE in another CTE
SELECT
product_name,
product_Key,
Category,
Subcategory,
Cost,
SUM(Sales_amount) AS Total_sales,
SUM(quantity) AS Total_quantity,
COUNT(DISTINCT customer_key) AS Total_customer,
COUNT(DISTINCT order_date) AS Total_orders,
MAX(Order_date)AS Last_Sale_date,
DATEDIFF(MONTH, MIN(Order_date), MAX(Order_date)) AS Lifespan,
ROUND(AVG(CAST(Sales_amount AS FLOAT)/NULLIF(quantity,0)),1) AS Avg_selling_price
FROM Product_table
GROUP BY product_name,
        product_key,
        Category,
        Subcategory,
        Cost)
 SELECT
product_name,
Category,
Subcategory,
Cost,
DATEDIFF(MONTH, Last_Sale_date, GETDATE()) AS Recency_by_month,
CASE
    WHEN Total_sales > 50000 THEN 'High Performer'
    WHEN Total_sales >= 10000 THEN 'Mid Range'
    ELSE 'Low Performer'
END AS Customer_segment,
Total_sales,
Total_quantity,
Total_customer,
Total_orders,
Last_Sale_date,
Lifespan,
Avg_selling_price,
-- Average Order Revenue
CASE 
    WHEN Total_orders =0 THEN 0
    ELSE Total_sales/ Total_orders
END AS Average_Order_revenue,
--Average Monthly revenue
CASE
    WHEN lifespan =0  THEN Total_sales
    ELSE Total_sales/Lifespan 
END AS Average_Monthly_revenue
FROM Product_Aggregate
