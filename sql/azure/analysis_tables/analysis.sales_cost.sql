create table analysis.sales_cost (
    date DATE,
    restaurant_name VARCHAR(50),
    product_name VARCHAR(50),
    category_name VARCHAR(50),
    num_sold INT,
    sales_euro DECIMAL(38,2),
    cost_euro DECIMAL(38,2)
)

insert into analysis.sales_cost
    select 
        date,
        restaurant_name,
        product_name,
        category_name,
        num_sold,
        sales_euro,
        cost_euro
    from
        ProductSalesCostProfitDaily

-- select * from analysis.sales_cost
