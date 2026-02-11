WITH CTE_Totalsales AS
(
	SELECT
	customerid,
	SUM(Sales) AS Totalsales
	FROM sales.Orders
	GROUP BY CustomerID
)
, Last_order AS(
				SELECT
				Customerid,
				MAX(orderdate) AS Last_orders
				FROM sales.Orders
				GROUP BY CustomerID
)
, Customer_Rank AS (
					SELECT
					customerid,
					Totalsales,
					RANK() OVER(ORDER BY Totalsales DESC) AS Customerrank
					FROM CTE_Totalsales
),
Customer_segment AS(
					SELECT
					customerid,
					CASE WHEN Totalsales> 100 THEN 'High'
					WHEN totalsales> 50 THEN 'Medium'
					ELSE 'Low'
					END Customer_segments
					FROM CTE_Totalsales
)
SELECT 
C.Customerid,
c.firstname,
c.Lastname,
L.Last_orders,
Customerrank,
COALESCE(cts.Totalsales,0) AS Total_sales,
Customer_segments
FROM sales.Customers AS c
LEFT JOIN  CTE_Totalsales AS cts
ON CTS.CustomerID= c.CustomerID
LEFT JOIN Last_order AS L
ON L.CustomerID= c.CustomerID
LEFT JOIN Customer_Rank AS R
ON R.CustomerID = c.CustomerID
LEFT JOIN Customer_segment AS S
ON s.customerid= c.CustomerID