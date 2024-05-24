-- CREATE REPORTING SCHEMA
create schema if not exists reporting;

drop table if exists 
	reporting.dim_ingredient_cost,
	reporting.dim_order_details,
	reporting.dim_product_category,
	reporting.dim_product_ingredients,
	reporting.dim_product_price,
	reporting.dim_products,
	reporting.dim_takeaway,
	reporting.fact_orders;

-- dim_ingredient_cost
create table if not exists reporting.dim_ingredient_cost (
	ingredient_name TEXT,
	cost_kg NUMERIC,
	ingredient_id INT PRIMARY KEY
);

insert into reporting.dim_ingredient_cost (
	ingredient_name, cost_kg, ingredient_id
)
select * from staging.ingredient_cost;

select * from reporting.dim_ingredient_cost;


-- dim_order_details
create table if not exists reporting.dim_order_details (
	order_no TEXT,
	product_id INT,
	amount INT,
	row_id INT PRIMARY KEY
);

insert into reporting.dim_order_details (
	order_no, product_id, amount, row_id
)
select od.order_no, p.product_id, od.amount, od.row_id 
from staging.order_details od
join staging.products p on p.product_name = od.product_name;

select * from reporting.dim_order_details
order by order_no ASC;

select distinct(product_id) from reporting.dim_order_details;

-- dim_takeaway
create table if not exists reporting.dim_takeaway (
	takeaway_id SERIAL PRIMARY KEY,
	takeaway TEXT
);

insert into reporting.dim_takeaway (
	takeaway
)
select distinct(takeaway) from staging.orders;

select * from reporting.dim_takeaway;


-- fact_orders
create table if not exists reporting.fact_orders (
	timestamp TIMESTAMP,
	order_no TEXT PRIMARY KEY,
	takeaway_id INT,
	restaurant_id VARCHAR(6)
);

insert into reporting.fact_orders (
	timestamp, order_no, takeaway_id, restaurant_id
)
select o.timestamp, o.order_no, ta.takeaway_id, o.restaurant_id
from staging.orders o
join reporting.dim_takeaway ta on o.takeaway = ta.takeaway;

select * from reporting.fact_orders;


-- dim_product_category
create table if not exists reporting.dim_product_category (
	category_name TEXT,
	category_id INT PRIMARY KEY
);

insert into reporting.dim_product_category (
	category_name, category_id
)
select * from staging.product_category;

select * from reporting.dim_product_category;


-- dim_product_ingredients
create table if not exists reporting.dim_product_ingredients (
	amount_kg NUMERIC,
	ingredient_id INT,
	product_id INT,
	recipe_id INT PRIMARY KEY
);

insert into reporting.dim_product_ingredients (
	amount_kg, ingredient_id, product_id, recipe_id
)
select * from staging.product_ingredients;

select * from reporting.dim_product_ingredients;


-- dim_product_price
create table if not exists reporting.dim_product_price (
	price NUMERIC,
	price_id INT PRIMARY KEY
);

insert into reporting.dim_product_price (
	price, price_id
)
select * from staging.product_price;

select * from reporting.dim_product_price;


-- dim_products
create table if not exists reporting.dim_products (
	product_name TEXT,
	product_id INT PRIMARY KEY,
	category_id INT,
	price_id INT
);

insert into reporting.dim_products (
	product_name, product_id, category_id, price_id
)
select * from staging.products;

select * from reporting.dim_products;














