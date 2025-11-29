CREATE OR REPLACE VIEW v_Finance_Model AS
    SELECT 
        f.amount,
        d.fulldatealternatekey AS ReportDate,
        d.englishmonthname AS ReportMonth,
        d.calendarquarter AS ReportQuarter,
        d.calendaryear AS ReportYear,
        o.OrganizationName,
        a.AccountName,
        a.AccountType,
        coalesce(a.Sort_Index , 99) as SortIndex,
        sc.ScenarioName,
        f.DateKey,
        f.OrganizationKey,
        f.AccountKey,
        f.ScenarioKey
    FROM
        factfinance f
            LEFT JOIN
        dimscenario sc ON f.ScenarioKey = sc.ScenarioKey
            LEFT JOIN
        dimdate d ON f.datekey = d.datekey
            LEFT JOIN
        dimorganization o ON f.organizationkey = o.organizationkey
            LEFT JOIN
        dimaccount a ON f.accountkey = a.accountkey
;
-- ----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_CallCenter_Model AS
SELECT
    cc.Calls AS TotalCalls,
    cc.AutomaticResponses,
    (cc.Calls - cc.AutomaticResponses) AS HandledCalls,
    cc.Orders AS OrdersFromCalls,
    cc.IssuesRaised,
    cc.ServiceGrade,
    cc.TotalOperators,
    d.FullDateAlternateKey AS ReportDate,
    d.EnglishDayNameOfWeek AS DayName,
    d.EnglishMonthName AS ReportMonth,
    d.CalendarYear AS ReportYear,
    cc.Shift,
    cc.WageType,
    cc.DateKey
FROM
    FactCallCenter cc
LEFT JOIN
    DimDate d ON cc.DateKey = d.DateKey;
-- ----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW v_Sales_Model AS
SELECT 
    s.OrderQuantity,
    s.SalesAmount,
    s.SalesOrderNumber,
    d.FullDateAlternateKey AS ReportDate,
    d.EnglishMonthName AS ReportMonth,
    d.CalendarQuarter AS ReportQuarter,
    d.CalendarYear AS ReportYear,
    p.EnglishProductName AS ProductName,
    psc.EnglishProductSubcategoryName AS ProductSubcategoryName,
    CASE
        WHEN p.EnglishProductName LIKE 'Mountain-%' THEN 'Bikes'
        WHEN psc.ProductCategoryKey = 1 THEN 'Bikes'
        WHEN psc.ProductCategoryKey = 2 THEN 'Components'
        WHEN psc.ProductCategoryKey = 3 THEN 'Clothing'
        WHEN psc.ProductCategoryKey = 4 THEN 'Accessories'
        WHEN p.ProductSubcategoryKey IS NULL OR p.ProductSubcategoryKey = 0 THEN 'Components'
        ELSE 'Other'
    END AS ProductCategoryName,
    s.OrderDateKey AS DateKey, 
    s.ProductKey,
    s.CustomerKey
FROM
    factinternetsales s
    LEFT JOIN dimdate d ON s.OrderDateKey = d.DateKey
    LEFT JOIN dimproduct p ON s.ProductKey = p.ProductKey
    LEFT JOIN dimproductsubcategory psc ON p.ProductSubcategoryKey = psc.ProductSubcategoryKey
    LEFT JOIN dimproductcategory pc ON psc.ProductCategoryKey = pc.ProductCategoryKey
;