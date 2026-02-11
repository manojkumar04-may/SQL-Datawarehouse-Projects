-- Month wise cummulative Analysis

SELECT
Order_date,
Total_sales,
SUM(Total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS Running_total_sales,
AVG(Avg_price) OVER(PARTITION BY order_date ORDER BY order_date) AS Moving_Avg_Price
FROM
(
	SELECT 
	DATETRUNC(month,order_date) As Order_date,
	SUM(sales_amount) AS Total_sales,
	AVG(price) AS Avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL 
	GROUP BY DATETRUNC(month,order_date)
)T

-- Year wise cummulative Analysis

SELECT
Order_date,
Total_sales,
SUM(Total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS Running_total_sales,
AVG(Avg_price) OVER(PARTITION BY order_date ORDER BY order_date) AS Moving_Avg_Price
FROM
(
	SELECT 
	DATETRUNC(Year,order_date) As Order_date,
	SUM(sales_amount) AS Total_sales,
	AVG(price) AS Avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL 
	GROUP BY DATETRUNC(YEAR,order_date)
)T

