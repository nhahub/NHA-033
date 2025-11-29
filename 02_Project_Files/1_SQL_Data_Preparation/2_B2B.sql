create view Top_Performing_Resellers as
    SELECT 
    r.ResellerName,
    r.BusinessType,
    COUNT(fs.SalesOrderNumber) AS TotalOrders,
    SUM(fs.SalesAmount) AS TotalRevenue,
    SUM(fs.SalesAmount - fs.TotalProductCost) AS TotalProfit,
    AVG(fs.SalesAmount) AS AvgOrderValue
FROM factresellersales fs
JOIN dimreseller r ON fs.ResellerKey = r.ResellerKey
GROUP BY r.ResellerName, r.BusinessType
ORDER BY TotalProfit DESC;

-- --------------------------------------------------------------------------------------------

create view Sales_Representative_Performance as
SELECT 
   concat(e.FirstName,' ',e.LastName)as Full_name,
    t.SalesTerritoryRegion,
    SUM(fs.SalesAmount) AS TotalB2BSales
FROM factresellersales fs
JOIN dimemployee e ON fs.EmployeeKey = e.EmployeeKey
JOIN dimsalesterritory t ON fs.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY e.FirstName, e.LastName, t.SalesTerritoryRegion
ORDER BY TotalB2BSales DESC;

-- ----------------------------------------------------------------------------------------

create view Product_Preference_by_Business_Type as
SELECT 
    r.BusinessType,
    p.EnglishProductName,
    SUM(fs.OrderQuantity) AS ItemsSold
FROM factresellersales fs
JOIN dimreseller r ON fs.ResellerKey = r.ResellerKey
JOIN dimproduct p ON fs.ProductKey = p.ProductKey
GROUP BY r.BusinessType, p.EnglishProductName
ORDER BY r.BusinessType, ItemsSold DESC;
