-- 1. Run the "CREATE VIEW" script separately
CREATE VIEW TempMonthlyProfit AS
WITH SalesCost AS (
    SELECT 
        restaurant_name,
        YEAR(date) AS year,
        MONTH(date) AS month_no,
        SUM(sales_euro) AS sales,
        SUM(cost_euro) AS cost
    FROM analysis.sales_cost
    GROUP BY 
        restaurant_name,
        YEAR(date),
        MONTH(date)
),
WorkingHoursSalaries AS (
    SELECT 
        restaurant_name,
        YEAR(date) AS year,
        MONTH(date) AS month_no,
        SUM(salary_euro) AS salaries
    FROM analysis.working_hours_salaries
    GROUP BY 
        restaurant_name,
        YEAR(date),
        MONTH(date)
)
SELECT 
    sc.restaurant_name,
    sc.year,
    sc.month_no,
    DATENAME(MONTH, DATEFROMPARTS(sc.year, sc.month_no, 1)) AS month,
    sc.sales,
    sc.cost,
    CAST(ROUND(whs.salaries, 2) AS DECIMAL(18, 2)) AS salaries,
    sc.sales - sc.cost - whs.salaries AS profit
FROM 
    SalesCost sc
JOIN 
    WorkingHoursSalaries whs 
    ON sc.restaurant_name = whs.restaurant_name
    AND sc.year = whs.year
    AND sc.month_no = whs.month_no;



-- 2. Create table, insert data from the view & drop the view 
create table analysis.restaurant_profit_monthly (
    restaurant_name VARCHAR(50),
    year INT,
    month_no INT,
    month VARCHAR(50),
    sales DECIMAL(18,2),
    cost DECIMAL(18,2),
    salaries DECIMAL(18,2),
    profit DECIMAL(18,2)
);

INSERT INTO analysis.restaurant_profit_monthly
    select * from TempMonthlyProfit;

DROP VIEW TempMonthlyProfit;

SELECT * FROM analysis.restaurant_profit_monthly
ORDER BY 
    year, 
    month_no, 
    restaurant_name;