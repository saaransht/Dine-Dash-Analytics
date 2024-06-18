CREATE TABLE analysis.products_sold_weekly (
    year INT,
    month_no INT,
    month_name NVARCHAR(50),
    week_no INT,
    restaurant_name NVARCHAR(100),
    num_products INT,
    sales_euro DECIMAL(18, 2)
);

INSERT INTO analysis.products_sold_weekly (year, month_no, month_name, week_no, restaurant_name, num_products, sales_euro)
SELECT 
    DATEPART(year, date) as year,
    DATEPART(month, date) as month_no,
    FORMAT(date, 'MMMM') as month_name,
    DATEPART(week, date) as week_no,
    restaurant_name,
    SUM(num_products) as num_products,
    SUM(sales_euro) as sales_euro
FROM dbo.ProductsSoldDaily
GROUP BY
    DATEPART(year, date),
    DATEPART(month, date),
    FORMAT(date, 'MMMM'),
    DATEPART(week, date),
    restaurant_name;