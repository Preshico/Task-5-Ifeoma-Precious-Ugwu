--Sales & Revenue Analysis
SELECT
	COUNT(OrderID) AS Total_Orders,
	ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
	ROUND(AVG(TotalPrice), 2) AS Avg_Order_Value,
	ROUND(MIN(TotalPrice), 2) AS Min_Order_Value,
	ROUND(MAX(TotalPrice), 2) AS Max_Order_Value
FROM[dbo].[Sheet1$]

SELECT
MONTH(Date) AS Month_Number,
DATENAME(MONTH, Date) AS Month_Name,
COUNT(OrderID) AS Total_Orders,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
ROUND(AVG(TotalPrice), 2) AS Avg_Order_Value
FROM[dbo].[Sheet1$]
GROUP BY MONTH(Date), DATENAME(MONTH, Date)
ORDER BY Month_Number

-- Product Performance
SELECT
Product,
COUNT(OrderID) AS Total_Orders,
SUM(Quantity) AS Total_Quantity,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
ROUND(AVG(TotalPrice), 2) AS Avg_Order_Value
FROM [dbo].[Sheet1$]
GROUP BY Product
ORDER BY Total_Revenue DESC

SELECT TOP 1 'Best Product' AS Category,
Product,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue
FROM [dbo].[Sheet1$]
GROUP BY Product
HAVING SUM(TotalPrice) = (
SELECT MAX(Total_Revenue)
FROM (
SELECT SUM(TotalPrice) AS Total_Revenue
FROM [dbo].[Sheet1$]
GROUP BY Product
) AS MaxRevenue
)

UNION ALL

SELECT TOP 1 'Worst Product' AS Category,
Product,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue
FROM [dbo].[Sheet1$]
GROUP BY Product
HAVING SUM(TotalPrice) = (
SELECT MIN(Total_Revenue)
FROM(
SELECT SUM(TotalPrice) AS Total_Revenue
FROM [dbo].[Sheet1$]
GROUP BY Product
) AS MinRevenue
)

-- Payment Method Analysis

SELECT
PaymentMethod,
COUNT(OrderID) AS Total_Orders,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
ROUND(AVG(TotalPrice), 2) AS Avg_Order_Value,
ROUND(COUNT(OrderID) * 100.0/ SUM(COUNT(OrderID)) OVER(), 2) AS Order_Percentage
FROM [dbo].[Sheet1$]
GROUP BY PaymentMethod
ORDER BY Total_Orders DESC 

-- Best and Least Used Payment Method
SELECT 'Most Used' AS Category,
PaymentMethod,
COUNT(OrderID) As Total_Orders,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue
FROM[dbo].[Sheet1$]
GROUP BY PaymentMethod
HAVING COUNT(OrderID) = (
SELECT MAX(Total_Orders)
FROM(
SELECT COUNT(OrderID) AS Total_Orders
FROM [dbo].[Sheet1$]
GROUP BY PaymentMethod
) AS MaxOrders
)

UNION ALL

SELECT 'Least Used' AS Category,
PaymentMethod,
COUNT(OrderID) AS Total_Orders,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue
FROM [dbo].[Sheet1$]
GROUP BY PaymentMethod
HAVING COUNT(OrderID) = (
SELECT MIN(Total_Orders)
FROM(
SELECT COUNT(OrderID) AS Total_Orders
FROM [dbo].[Sheet1$]
GROUP BY PaymentMethod
) AS MinOrders
)

-- CUSTOMER BEHAVIOUR
--QUERY7 - TOP 10 CUSTOMERS BY REVENUE:
SELECT TOP 10
CustomerID,
COUNT(OrderID) AS Total_Orders,
SUM(Quantity) AS Total_Quantity,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
ROUND(AVG(TotalPrice), 2) AS Avg_Order_Value
FROM [dbo].[Sheet1$]
GROUP BY CustomerID
ORDER BY Total_Revenue DESC

-- Overall Customer Behaviour Stats
SELECT
COUNT(DISTINCT CustomerID) AS Total_Customers,
ROUND(AVG(Total_Revenue), 2) AS Avg_Revenue_Per_Customer,
ROUND(MAX(Total_Revenue), 2) AS Highest_Customer_Revenue,
ROUND(MIN(Total_Revenue), 2) AS Lowest_Customer_Revenue,
ROUND(AVG(Total_Orders), 2) AS Avg_Orders_Per_Customer
FROM(
SELECT
CustomerID,
COUNT(OrderID) AS Total_Orders,
SUM(TotalPrice) AS Total_Revenue
FROM [dbo].[Sheet1$]
GROUP BY CustomerID
) AS CustomerSummary

--MONTHLY TRENDS
--Query 9-Monthly Trends Summary:
SELECT
MONTH(Date) AS Month_Number,
DATENAME(MONTH, Date) AS Month_Name,
COUNT(OrderID) AS Total_Orders,
SUM(Quantity) AS Total_Quantity,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
ROUND (AVG(TotalPrice), 2) AS Avg_Order_Value
FROM [dbo].[Sheet1$]
GROUP BY MONTH(Date), DATENAME(MONTH, Date)
ORDER BY Month_Number

--Best and Worst Month
SELECT 'Best Month' AS Category,
DATENAME(MONTH, Date) AS Month_Name,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
COUNT(OrderID) AS Total_Orders
FROM[dbo].[Sheet1$]
GROUP BY DATENAME(MONTH, Date)
HAVING SUM(TotalPrice) = (
SELECT MAX (Monthly_Revenue)
FROM(
SELECT SUM(TotalPrice) AS Monthly_Revenue
FROM [dbo].[Sheet1$]
GROUP BY DATENAME(MONTH, Date)
) AS MaxMonth
)

UNION ALL
SELECT 'Worst Month' AS Category,
DATENAME(MONTH, Date) AS Month_Name,
ROUND(SUM(TotalPrice), 2) AS Total_Revenue,
COUNT(OrderID) AS Total_Orders
FROM[dbo].[Sheet1$]
GROUP BY DATENAME(MONTH, Date)
HAVING SUM(TotalPrice) = (
SELECT MIN (Monthly_Revenue)
FROM(
SELECT SUM(TotalPrice) AS Monthly_Revenue
FROM [dbo].[Sheet1$]
GROUP BY DATENAME(MONTH, Date)
) AS MinMonth
)