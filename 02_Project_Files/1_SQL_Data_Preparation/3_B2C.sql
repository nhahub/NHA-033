CREATE VIEW v_B2C_Sales_Analysis AS
SELECT
    -- FactInternetSales
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    f.OrderQuantity,
    f.SalesAmount,
    f.TotalProductCost,
    f.TaxAmt,
    f.Freight,

    -- Your Custom Profit Calculations
    (f.SalesAmount - f.TotalProductCost) AS TotalProfit,
    (f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight) AS TotalNetProfit,

    -- Date Dimension
    d.FullDateAlternateKey AS OrderDate,
    d.CalendarYear,
    d.EnglishMonthName,
    d.MonthNumberOfYear,
    d.CalendarQuarter,
    d.DayNumberOfWeek,

    -- Product Dimension
    p.EnglishProductName,
    psc.EnglishProductSubcategoryName,
    pc.EnglishProductCategoryName,

    -- Customer Dimension
    c.CustomerKey,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    c.EmailAddress,

    -- Geography 
    g.City,
    g.StateProvinceName,
    g.EnglishCountryRegionName,
    g.PostalCode

FROM
    FactInternetSales f
LEFT JOIN
    DimDate d ON f.OrderDateKey = d.DateKey
LEFT JOIN
    DimCustomer c ON f.CustomerKey = c.CustomerKey
LEFT JOIN
    DimGeography g ON c.GeographyKey = g.GeographyKey
LEFT JOIN
    DimProduct p ON f.ProductKey = p.ProductKey
LEFT JOIN
    DimProductSubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
LEFT JOIN
    DimProductCategory pc ON psc.ProductCategoryKey = pc.ProductCategoryKey;

SELECT
    d.CalendarYear,
    Round(SUM(f.SalesAmount),2) AS TotalSales,
    -- Profit = SalesAmount - TotalProductCost
   round(SUM(f.SalesAmount - f.TotalProductCost),2) AS TotalProfit,
    -- NetProfit = SalesAmount - TotalProductCost - TaxAmt - Freight
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS TotalNetProfit
FROM
    FactInternetSales f
JOIN
    DimDate d ON f.OrderDateKey = d.DateKey
GROUP BY
    d.CalendarYear
ORDER BY
    d.CalendarYear;
    
    SELECT
    d.CalendarYear,
    d.MonthNumberOfYear,
    d.EnglishMonthName,
    round(SUM(f.SalesAmount),2) AS TotalSales,
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS TotalNetProfit
FROM
    FactInternetSales f
JOIN
    DimDate d ON f.OrderDateKey = d.DateKey
GROUP BY
    d.CalendarYear,
    d.MonthNumberOfYear,
    d.EnglishMonthName
ORDER BY
    d.CalendarYear,
    d.MonthNumberOfYear;
    
-- LTV

SELECT
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    -- LTV based on your NetProfit definition
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS CustomerLifetimeValue_NetProfit,
   round(SUM(f.SalesAmount),2) AS CustomerLifetimeValue_Sales,
    COUNT(DISTINCT f.SalesOrderNumber) AS TotalOrders,
    MAX(f.OrderDate) AS LastOrderDate
FROM
    FactInternetSales f
JOIN
    DimCustomer c ON f.CustomerKey = c.CustomerKey
GROUP BY
    c.CustomerKey,
    c.FirstName,
    c.LastName
ORDER BY
    CustomerLifetimeValue_NetProfit DESC
LIMIT 50; -- Show top 50 customers

-- most recent order date in the database
SET @MaxDate = (SELECT MAX(OrderDate) FROM FactInternetSales);

-- filtering for active customers
SELECT
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS CustomerLifetimeValue_NetProfit
FROM
    FactInternetSales f
JOIN
    DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE
    c.CustomerKey IN (
        -- Subquery to find customers active in the last 12 months
        SELECT DISTINCT CustomerKey
        FROM FactInternetSales
        WHERE OrderDate >= DATE_SUB(@MaxDate , INTERVAL 12 MONTH)
    )
GROUP BY
    c.CustomerKey,
    c.FirstName,
    c.LastName
ORDER BY
    CustomerLifetimeValue_NetProfit DESC
LIMIT 50;

SELECT
    p.EnglishProductName,
    SUM(f.OrderQuantity) AS TotalUnitsSold,
    round(SUM(f.SalesAmount),2) AS TotalSales,
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS TotalNetProfit
FROM
    FactInternetSales f
JOIN
    DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY
    p.EnglishProductName
ORDER BY
    TotalNetProfit DESC 
-- Rank by profit
-- ORDER BY TotalSales DESC
LIMIT 20;

SELECT
    pc.EnglishProductCategoryName,
   round(SUM(f.SalesAmount),2) AS TotalSales,
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS TotalNetProfit
FROM
    FactInternetSales f
JOIN
    DimProduct p ON f.ProductKey = p.ProductKey
JOIN
    DimProductSubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
JOIN
    DimProductCategory pc ON psc.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY
    pc.EnglishProductCategoryName
ORDER BY
    TotalNetProfit DESC;
    
    SELECT
    g.EnglishCountryRegionName,
    round(SUM(f.SalesAmount),2) AS TotalSales,
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS TotalNetProfit,
    COUNT(DISTINCT f.CustomerKey) AS TotalCustomers
FROM
    FactInternetSales f
JOIN
    DimCustomer c ON f.CustomerKey = c.CustomerKey
JOIN
    DimGeography g ON c.GeographyKey = g.GeographyKey
GROUP BY
    g.EnglishCountryRegionName
ORDER BY
    TotalSales DESC;
    
    SELECT
    g.EnglishCountryRegionName,
    g.StateProvinceName,
    round(SUM(f.SalesAmount),2) AS TotalSales,
    round(SUM(f.SalesAmount - f.TotalProductCost - f.TaxAmt - f.Freight),2) AS TotalNetProfit
FROM
    FactInternetSales f
JOIN
    DimCustomer c ON f.CustomerKey = c.CustomerKey
JOIN
    DimGeography g ON c.GeographyKey = g.GeographyKey
GROUP BY
    g.EnglishCountryRegionName,
    g.StateProvinceName
ORDER BY
    TotalSales DESC;
    
    -- One-Time Buyers vs. Repeat Customers vs. Loyal Customers

-- CTE to first get order counts per customer
WITH CustomerOrderData AS (
    SELECT
        CustomerKey,
        COUNT(DISTINCT SalesOrderNumber) AS TotalOrders,
        SUM(SalesAmount) AS TotalSales,
        SUM(SalesAmount - TotalProductCost - TaxAmt - Freight) AS TotalNetProfit
    FROM
        FactInternetSales
    GROUP BY
        CustomerKey
),
-- Assign segments to each customer
CustomerSegments AS (
    SELECT
        *,
        CASE
            WHEN TotalOrders = 1 THEN '1. One-Time Buyer (1 order)'
            WHEN TotalOrders BETWEEN 2 AND 4 THEN '2. Repeat Customer (2-4 orders)'
            ELSE '3. Loyal Customer (5+ orders)'
        END AS CustomerSegment
    FROM
        CustomerOrderData
)
-- Aggregate the data by the new segments
SELECT
    CustomerSegment,
    COUNT(CustomerKey) AS NumberOfCustomers,
    round(SUM(TotalSales),2) AS TotalSalesInSegment,
    round(SUM(TotalNetProfit),2) AS TotalNetProfitInSegment,
    round(AVG(TotalNetProfit),0) AS AvgNetProfitPerCustomer,
    round(AVG(TotalOrders),0) AS AvgOrdersPerCustomer
FROM
    CustomerSegments
GROUP BY
    CustomerSegment
ORDER BY
    CustomerSegment;