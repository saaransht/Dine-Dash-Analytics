-- EXPORT REPORTING TABLES INTO .CSV (in psql tool)

\copy reporting.dim_ingredient_cost TO 'REPOSITORY PATH/data/dw/dim_ingredient_cost.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_order_details TO 'REPOSITORY PATH/data/dw/dim_order_details.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_category TO 'REPOSITORY PATH/data/dw/dim_product_category.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_ingredients TO 'REPOSITORY PATH/data/dw/dim_product_ingredients.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_price TO 'REPOSITORY PATH/data/dw/dim_product_price.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_products TO 'REPOSITORY PATH/data/dw/dim_products.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_takeaway TO 'REPOSITORY PATH/data/dw/dim_takeaway.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.fact_orders TO 'REPOSITORY PATH/data/dw/fact_orders.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_titles TO 'REPOSITORY PATH/data/dw/dim_titles.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_restaurants TO 'REPOSITORY PATH/data/dw/dim_restaurants.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_salaries TO 'REPOSITORY PATH/data/dw/dim_salaries.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_cities TO 'REPOSITORY PATH/data/dw/dim_cities.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_postal_code TO 'REPOSITORY PATH/data/dw/dim_postal_code.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_employees TO 'REPOSITORY PATH/data/dw/dim_employees.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.fact_employee_shifts TO 'REPOSITORY PATH/data/dw/fact_employee_shifts.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_working_hours TO 'REPOSITORY PATH/data/dw/dim_working_hours.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);


-- TEST SAVING TO SECOND LOCATION
\copy reporting.dim_ingredient_cost TO 'REPOSITORY PATH/data/dw2/dim_ingredient_cost.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_order_details TO 'REPOSITORY PATH/data/dw2/dim_order_details.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_category TO 'REPOSITORY PATH/data/dw2/dim_product_category.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_ingredients TO 'REPOSITORY PATH/data/dw2/dim_product_ingredients.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_product_price TO 'REPOSITORY PATH/data/dw2/dim_product_price.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_products TO 'REPOSITORY PATH/data/dw2/dim_products.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_takeaway TO 'REPOSITORY PATH/data/dw2/dim_takeaway.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.fact_orders TO 'REPOSITORY PATH/data/dw2/fact_orders.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_titles TO 'REPOSITORY PATH/data/dw2/dim_titles.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_restaurants TO 'REPOSITORY PATH/data/dw2/dim_restaurants.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_salaries TO 'REPOSITORY PATH/data/dw2/dim_salaries.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_cities TO 'REPOSITORY PATH/data/dw2/dim_cities.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_postal_code TO 'REPOSITORY PATH/data/dw2/dim_postal_code.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_employees TO 'REPOSITORY PATH/data/dw2/dim_employees.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.fact_employee_shifts TO 'REPOSITORY PATH/data/dw2/fact_employee_shifts.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
\copy reporting.dim_working_hours TO 'REPOSITORY PATH/data/dw2/dim_working_hours.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);
