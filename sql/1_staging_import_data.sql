--- CREATE STAGING TABLES
drop table if exists
	staging.products,
	staging.product_price,
	staging.product_ingredients,
	staging.product_category,
	staging.ingredient_cost,
	staging.employees,
	staging.salaries,
	staging.employee_shifts,
	staging.salary_additions,
	staging.restaurants;

--- PRODUCTS TABLE
create table if not exists staging.products (
	product_name TEXT,
	product_id INT PRIMARY KEY,
	category_id INT,
	price_id INT
);

select * from staging.products;

--- PRODUCTS_PRICE TABLE
create table if not exists staging.product_price (
	price NUMERIC,
	price_id INT PRIMARY KEY
);

select * from staging.product_price;

--- PRODUCT_INGREDIENTS TABLE
create table if not exists staging.product_ingredients (
	amount_kg NUMERIC,
	ingredient_id INT,
	product_id INT,
	recipe_id INT PRIMARY KEY
);

select * from staging.product_ingredients;

--- PRODUCT_CATEGORY TABLE
create table if not exists staging.product_category (
	category_name TEXT,
	category_id INT PRIMARY KEY
);

select * from staging.product_category;

--- INGREDIENT_COST TABLE
create table if not exists staging.ingredient_cost (
	ingredient_name TEXT,
	cost_kg NUMERIC,
	ingredient_id INT PRIMARY KEY
);

select * from staging.ingredient_cost;

--- EMPLOYEES TABLE
create table if not exists staging.employees (
	first_name TEXT,
	last_name TEXT,
	street_address VARCHAR(100),
	city TEXT,
	postal_code INT,
	email VARCHAR (50),
	phone_number VARCHAR(15),
	employee VARCHAR(30),
	title TEXT,
	restaurant_id VARCHAR(6),
	employee_id VARCHAR(4) PRIMARY KEY,
	experience_years INT,
	salary_id INT
);

--- SALARIES TABLE
create table if not exists staging.salaries (
	salary_id INT PRIMARY KEY,
	experience_years INT,
	title TEXT,
	salary_h NUMERIC
);

--- EMPLOYEE_SHIFTS TABLE
create table if not exists staging.employee_shifts (
	date DATE,
	activity VARCHAR(3),
	time TIME,
	restaurant_id VARCHAR(6),
	employee_id VARCHAR(4)
);

--- SALARY_ADDITIONS TABLE
create table if not exists staging.salary_additions (
	addition_id SERIAL PRIMARY KEY,
	addition_type TEXT,
	addition_start TIME,
	addition_end TIME,
	hourly_addition NUMERIC,
	multiplier NUMERIC
);

--- RESTAURANTS TABLE
create table if not exists staging.restaurants (
	restaurant_id VARCHAR(6) PRIMARY KEY,
	restaurant_name TEXT,
	address VARCHAR(100),
	postal_code VARCHAR(10),
	city TEXT
);

/*
ADD DATA TO STAGING TABLES (in psql tool)
Connect to database in terminal: psql -U postgres -d pizza_restaurant
	OR use PSQL tool in pgAdmin

\copy staging.ingredient_cost(ingredient_name, cost_kg, ingredient_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/ingredient_cost.csv' DELIMITER ',' CSV HEADER;
\copy staging.product_category(category_name, category_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/product_category.csv' DELIMITER ',' CSV HEADER;
\copy staging.product_ingredients(amount_kg, ingredient_id, product_id, recipe_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/product_ingredients.csv' DELIMITER ',' CSV HEADER;
\copy staging.product_price(price, price_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/product_price.csv' DELIMITER ',' CSV HEADER;
\copy staging.products(product_name, product_id, category_id, price_id) FROM '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/products.csv' DELIMITER ',' CSV HEADER;
\copy staging.employees(first_name, last_name, street_address, city, postal_code, email, phone_number, employee, title, restaurant_id, employee_id, experience_years, salary_id) from '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/employee_details.csv' DELIMITER ',' CSV HEADER;
\copy staging.salaries(salary_id, experience_years, title, salary_h) from '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/salaries.csv' DELIMITER ',' CSV HEADER;
\copy staging.employee_shifts(date, activity, time, restaurant_id, employee_id) from '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/employee_shifts.csv' DELIMITER ',' CSV HEADER;
\copy staging.salary_additions(addition_type, addition_start, addition_end, hourly_addition, multiplier) from '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/salary_additions.csv' DELIMITER ',' CSV HEADER;
\copy staging.restaurants(restaurant_id, restaurant_name, address, postal_code, city) from '/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/restaurants.csv' DELIMITER ',' CSV HEADER;

select * from staging.ingredient_cost;
select * from staging.product_category;
select * from staging.product_ingredients;
select * from staging.product_price;
select * from staging.products;
select * from staging.employees;
select * from staging.salaries;
select * from staging.employee_shifts;
select * from staging.salary_additions;
select * from staging.restaurants;

*/


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























