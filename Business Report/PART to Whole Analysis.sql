-- which categories contribute the most to overall sales?
WITH Category_sales AS (
SELECT
category,
SUM(Sales_amount) AS Total_sales
FROM gold.fact_sales AS F 
LEFT JOIN gold.dim_products AS P
ON P.product_key= F.product_key
GROUP BY category)
SELECT
category,
Total_sales,
SUM(total_sales) OVER() Overall_sales,
CONCAT(ROUND((CAST(Total_sales AS FLOAT)/SUM(total_sales) over())*100,2),'%') As Percentage_of_Total_sales
FROM Category_sales
ORDER BY Total_sales DESC

