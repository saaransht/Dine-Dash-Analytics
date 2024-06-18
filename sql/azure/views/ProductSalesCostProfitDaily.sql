CREATE VIEW ProductSalesCostProfitDaily AS
WITH ProductIngredients AS (
    SELECT 
        dpi.product_id,
        dpi.ingredient_id,
        dci.cost_kg * dpi.amount_kg AS cost
    FROM dim_product_ingredients dpi
    JOIN dim_ingredient_cost dci ON dci.ingredient_id = dpi.ingredient_id
),
ProductCost AS (
    SELECT 
        dpi.product_id,
        dp.product_name,
        SUM(pi.cost) AS product_cost
    FROM dim_product_ingredients dpi
    JOIN ProductIngredients pi ON pi.ingredient_id = dpi.ingredient_id AND pi.product_id = dpi.product_id
    JOIN dim_products dp ON dp.product_id = dpi.product_id
    GROUP BY dpi.product_id, dp.product_name
),
ProductSales AS (
    SELECT 
        dod.order_no, 
        dp.product_name,
        dpg.category_name,
        dod.amount, 
        dpp.price * dod.amount AS sales_euro,
        pc.product_cost * dod.amount AS cost_euro
    FROM dim_order_details dod
    JOIN dim_products dp ON dp.product_id = dod.product_id
    JOIN dim_product_price dpp ON dpp.price_id = dp.price_id
    JOIN dim_product_category dpg ON dpg.category_id = dp.category_id
    JOIN ProductCost pc ON pc.product_id = dp.product_id
),
DateOrder AS (
    SELECT 
        dr.restaurant_name,
        CAST(fo.timestamp AS DATE) AS date,
        fo.order_no
    FROM dim_restaurants dr
    JOIN fact_orders fo ON fo.restaurant_id = dr.restaurant_id
)

SELECT 
    do.date,
    do.restaurant_name,
    ps.product_name,
    ps.category_name,
    SUM(ps.amount) AS num_sold,
    SUM(ps.sales_euro) AS sales_euro,
    SUM(ps.cost_euro) AS cost_euro,
    SUM(ps.sales_euro) - SUM(ps.cost_euro) AS profit_euro
FROM DateOrder do
JOIN ProductSales ps ON ps.order_no = do.order_no
GROUP BY do.date, do.restaurant_name, ps.product_name, ps.category_name
-- ORDER BY do.date, do.restaurant_name;
