--- CREATE DIMENSION TABLES
drop table if exists
	staging.products,
	staging.product_price,
	staging.product_ingredients,
	staging.product_category,
	staging.ingredient_cost;

--- PRODUCTS
create table if not exists staging.products (
	product_name TEXT,
	product_id INT PRIMARY KEY,
	category_id INT,
	price_id INT
);

select * from staging.products;

--- PRODUCTS PRICE
create table if not exists staging.product_price (
	price NUMERIC,
	price_id INT PRIMARY KEY
);

select * from staging.product_price;

--- PRODUCT INGREDIENTS
create table if not exists staging.product_ingredients (
	amount_kg NUMERIC,
	ingredient_id INT,
	product_id INT,
	recipe_id INT PRIMARY KEY
);

select * from staging.product_ingredients;

--- PRODUCT CATEGORY
create table if not exists staging.product_category (
	category_name TEXT,
	category_id INT PRIMARY KEY
);

select * from staging.product_category;

--- INGREDIENT COST
create table if not exists staging.ingredient_cost (
	ingredient_name TEXT,
	cost_kg NUMERIC,
	ingredient_id INT PRIMARY KEY
);

select * from staging.ingredient_cost;

/*
ADD DATA TO DIMENSION TABLES (in psql tool)
Connect to database in terminal: psql -U postgres -d pizza_restaurant
	OR use PSQL tool in pgAdmin

\copy staging.ingredient_cost(ingredient_name, cost_kg, ingredient_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/ingredient_cost.csv' DELIMITER ',' CSV HEADER;
\copy staging.product_category(category_name, category_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/product_category.csv' DELIMITER ',' CSV HEADER;
\copy staging.product_ingredients(amount_kg, ingredient_id, product_id, recipe_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/product_ingredients.csv' DELIMITER ',' CSV HEADER;
\copy staging.product_price(price, price_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/product_price.csv' DELIMITER ',' CSV HEADER;
\copy staging.products(product_name, product_id, category_id, price_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/products.csv' DELIMITER ',' CSV HEADER;

*/

select * from staging.ingredient_cost;
select * from staging.product_category;
select * from staging.product_ingredients;
select * from staging.product_price;
select * from staging.products;

--- CREATE ORDERS AND ORDER_DETAILS TABLES
drop table if exists 
	staging.orders,
	staging.order_details;
	
create table if not exists staging.orders (
	timestamp TIMESTAMP,
	order_no TEXT PRIMARY KEY,
	takeaway TEXT,
	restaurant_id VARCHAR(6)
);

create table if not exists staging.order_details (
	order_no TEXT,
	product_name TEXT,
	amount INT,
	row_id SERIAL PRIMARY KEY
);

/* ADD DATA TO ORDERS TABLE (in psql tool)
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_HKI001.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_HKI002.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_HKI003.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_TKU001.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_TKU002.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_TRE001.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_TRE002.csv' DELIMITER ',' CSV HEADER;
\copy staging.orders(timestamp, order_no, takeaway, restaurant_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_OUL001.csv' DELIMITER ',' CSV HEADER;

select * from staging.orders;

select distinct(restaurant_id) from staging.orders;

ADD DATA TO ORDER_DETAILS TABLE (in psql tool)
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_HKI001.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_HKI002.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_HKI003.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_TKU001.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_TKU002.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_TRE001.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_TRE002.csv' DELIMITER ',' CSV HEADER;
\copy staging.order_details(order_no, product_name, amount) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/order_details_OUL001.csv' DELIMITER ',' CSV HEADER;

select * from staging.order_details;

select distinct(product_name) from staging.order_details;

select * from staging.order_details
limit 100;

select count(row_id) from staging.order_details;
*/























