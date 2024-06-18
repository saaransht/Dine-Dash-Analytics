-- Products (name) sold by day: Restaurant name, Product name, Number of items sold, Sales in euro
CREATE VIEW ProductsSoldDaily AS
with ProductSales AS (
select dod.order_no, 
        dp.product_name,
        dpg.category_name,
        dod.amount, 
        (dpp.price * dod.amount) as euro
from dim_order_details dod
join dim_products dp on dp.product_id = dod.product_id
join dim_product_price dpp on dpp.price_id = dp.price_id
join dim_product_category dpg on dpg.category_id = dp.category_id
),
DateOrder AS (
select dr.restaurant_name,
        cast(fo.timestamp as DATE) as date,
--        datepart(HOUR, fo.timestamp) as hour,
        fo.order_no
from dim_restaurants dr
join fact_orders fo on fo.restaurant_id = dr.restaurant_id
)

select do.restaurant_name, 
        do.date, 
        ps.product_name, 
        sum(ps.amount) as num_products,
        sum(ps.euro) as sales_euro
from DateOrder do
join ProductSales ps on ps.order_no = do.order_no
group by do.restaurant_name, do.date, ps.product_name
