/* Analze the yearly performance of Products by comparing their sales to both the 
Average Sales performance of the product and the previous year's sales*/


WITH Current_Year_Product_sales AS(
SELECT
YEAR(order_date) AS Order_year,
P.Product_name,
SUM(F.sales_amount) AS Current_sales
 FROM GOLD.fact_sales AS F
LEFT JOIN gold.dim_products AS P
ON F.product_key = P.product_key
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date), P.Product_name)
SELECT
Order_year,
Product_name,
Current_sales,
AVG(current_sales) OVER( PARTITION BY Product_name) AS Avg_sales,
current_sales - AVG(current_sales) OVER( PARTITION BY Product_name) AS Diff_Avg,
CASE 
	WHEN current_sales - AVG(current_sales) OVER( PARTITION BY Product_name) >0 THEN 'Above Avg'
	WHEN current_sales - AVG(current_sales) OVER( PARTITION BY Product_name) <0 THEN 'Below Avg'
	ELSE 'Avg'
END AS Avg_comparison,
/* Year-on-Year Analysis */
LAG(Current_sales) OVER(PARTITION BY Product_name ORDER BY Order_year) AS Previous_Year,
current_sales - LAG(Current_sales) OVER(PARTITION BY Product_name ORDER BY Order_year) as Diff_Previous_Year,
CASE 
	WHEN current_sales - LAG(Current_sales) OVER(PARTITION BY Product_name ORDER BY Order_year) >0 THEN 'Increase'
	WHEN current_sales - LAG(Current_sales) OVER(PARTITION BY Product_name ORDER BY Order_year) <0 THEN 'Decrease'
	ELSE 'No change'
END AS Previous_year_Comparison
FROM Current_Year_Product_sales
ORDER BY product_name, Order_year