CREATE TABLE analysis.products_sold_monthly (
    year INT,
    month_no INT,
    month_name NVARCHAR(50),
    restaurant_name NVARCHAR(100),
    num_products INT,
    sales_euro DECIMAL(18, 2)
);

INSERT INTO analysis.products_sold_monthly (year, month_no, month_name, restaurant_name, num_products, sales_euro)
SELECT 
    DATEPART(year, date) as year,
    DATEPART(month, date) as month_no,
    FORMAT(date, 'MMMM') as month_name,
    restaurant_name,
    SUM(num_products) as num_products,
    SUM(sales_euro) as sales_euro
FROM dbo.ProductsSoldDaily
GROUP BY
    DATEPART(year, date),
    DATEPART(month, date),
    FORMAT(date, 'MMMM'),
    restaurant_name;