CREATE OR REPLACE VIEW v_Inventory_Model AS

SELECT
    f.ProductKey,
    f.DateKey,
    p.EnglishProductName,
    ps.EnglishProductSubcategoryName,
    pc.EnglishProductCategoryName,
    p.Color AS ProductColor,
    p.Size AS ProductSize,
    p.StandardCost,
    d.FullDateAlternateKey AS ReportDate,
    d.EnglishMonthName AS ReportMonth,
    d.CalendarYear AS ReportYear,
    f.UnitCost,  
    f.UnitsIn,  
    f.UnitsOut,    
    f.UnitsBalance,   
    ROUND( (f.UnitsBalance * f.UnitCost), 2 ) AS InventoryValue

FROM
    FactProductInventory f
LEFT JOIN
    DimDate d ON f.DateKey = d.DateKey
LEFT JOIN
    DimProduct p ON f.ProductKey = p.ProductKey
LEFT JOIN
    DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN
    DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey;