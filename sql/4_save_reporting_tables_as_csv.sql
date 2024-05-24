-- EXPORT REPORTING TABLES INTO .CSV (in psql tool)

\copy reporting.dim_ingredient_cost TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_ingredient_cost.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_order_details TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_order_details.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_category TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_product_category.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_ingredients TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_product_ingredients.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_price TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_product_price.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_products TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_products.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_takeaway TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/dim_takeaway.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.fact_orders TO '/Users/joonas/VSCode/Restaurant Sales Analysis/data/dw/fact_orders.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
