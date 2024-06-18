CREATE VIEW IngredientAmountCostDaily AS
WITH ProductIngredients AS (
    SELECT 
        dpi.product_id,
        dic.ingredient_name,
        dpi.ingredient_id,
        dpi.amount_kg,
        dic.cost_kg
    FROM dim_product_ingredients dpi
    JOIN dim_ingredient_cost dic on dic.ingredient_id = dpi.ingredient_id
),
ProductSales AS (
    SELECT 
        dod.order_no, 
        dp.product_name,
        dp.product_id,
        dod.amount
    FROM dim_order_details dod
    JOIN dim_products dp ON dp.product_id = dod.product_id
),
IngredientAmount AS (
        SELECT ps.order_no,
                ps.product_name,
                pi.ingredient_name,
                ps.amount * pi.amount_kg as amount_kg,
                ps.amount * pi.amount_kg * pi.cost_kg as cost
        FROM ProductSales ps
        JOIN ProductIngredients pi on pi.product_id = ps.product_id
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
        ia.ingredient_name,
        sum(ia.amount_kg) as amount_kg,
        sum(ia.cost) as cost
FROM DateOrder do
JOIN IngredientAmount ia on ia.order_no = do.order_no
GROUP BY do.date, do.restaurant_name, ia.ingredient_name
-- ORDER BY do.restaurant_name, do.date