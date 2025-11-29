USE adventureworks_dw;
CREATE OR REPLACE VIEW Customer_Market_Insights AS
SELECT
    c.CustomerKey,
    c.Gender,
    c.EnglishEducation AS Education,
    c.EnglishOccupation AS Occupation,
    c.YearlyIncome,
    pc.EnglishProductCategoryName AS ProductCategory,
    ps.EnglishProductSubcategoryName AS ProductSubcategory,
    p.EnglishProductName AS ProductName,
    f.SalesOrderNumber,
    f.OrderDate,
    f.SalesAmount,
    f.TotalProductCost,
    (f.SalesAmount - f.TotalProductCost) AS Profit,
    s.SalesReasonName,
    s.SalesReasonReasonType,
    sr.EnglishProductCategoryName AS SurveyPreferredCategory
FROM factInternetSales f
JOIN dimCustomer c ON f.CustomerKey = c.CustomerKey
JOIN dimProduct p ON f.ProductKey = p.ProductKey
JOIN dimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
JOIN dimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
LEFT JOIN factInternetSalesReason fsr ON f.SalesOrderNumber = fsr.SalesOrderNumber
LEFT JOIN dimSalesReason s ON fsr.SalesReasonKey = s.SalesReasonKey
LEFT JOIN factsurveyresponse sr ON c.CustomerKey = sr.CustomerKey;
-- Q1: Customer Demographic Profile
SELECT 
    Gender,
    Education,
    Occupation,
    AVG(YearlyIncome) AS AvgIncome,
    COUNT(CustomerKey) AS CustomerCount
FROM Customer_Market_Insights
GROUP BY Gender, Education, Occupation
ORDER BY CustomerCount DESC;
-- Q2: Preferred Product Categories (Survey)
SELECT 
    SurveyPreferredCategory,
    COUNT(DISTINCT CustomerKey) AS CustomerCount
FROM Customer_Market_Insights
WHERE SurveyPreferredCategory IS NOT NULL
GROUP BY SurveyPreferredCategory
ORDER BY CustomerCount DESC;
-- Q3: Primary Purchase Reasons
SELECT 
    SalesReasonName,
    SalesReasonReasonType,
    COUNT(DISTINCT SalesOrderNumber) AS OrdersCount
FROM Customer_Market_Insights
WHERE SalesReasonName IS NOT NULL
GROUP BY SalesReasonName, SalesReasonReasonType
ORDER BY OrdersCount DESC;
-- Q4: Reason vs Purchase Value
SELECT 
    SalesReasonReasonType,
    AVG(SalesAmount) AS AvgSalesValue,
    AVG(Profit) AS AvgProfit
FROM Customer_Market_Insights
WHERE SalesReasonReasonType IS NOT NULL
GROUP BY SalesReasonReasonType
ORDER BY AvgSalesValue DESC;