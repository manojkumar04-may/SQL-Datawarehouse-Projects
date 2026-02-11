/* Segment Product into Cost Ranges and count how many Products fall into each segemnt*/
WITH Product_Segment AS(
SELECT 
Product_key,
Product_name,
cost,
CASE WHEN cost <100 THEN 'Below 100'
	 WHEN Cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN Cost BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END Cost_Range
FROM gold.dim_products)

SELECT 
Cost_Range,
COUNT(Product_name) As Total_Products
FROM Product_Segment
GROUP BY Cost_Range
