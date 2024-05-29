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
	reporting.fact_orders,
	reporting.dim_titles,
	reporting.dim_restaurants,
	reporting.dim_salaries,
	staging.cities,
	reporting.dim_cities,
	staging.postal_code,
	reporting.dim_postal_code,
	reporting.dim_employees,
	reporting.fact_employee_shifts;

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

-- dim_titles
create table if not exists reporting.dim_titles (
	title_id SERIAL PRIMARY KEY,
	title TEXT
);

INSERT INTO reporting.dim_titles(title)
	select distinct(title) from staging.employees;


-- dim_restaurants
create table if not exists reporting.dim_restaurants (
	restaurant_id VARCHAR(6) PRIMARY KEY,
	restaurant_name TEXT,
	address VARCHAR(100),
	postal_code VARCHAR(10)
);

INSERT INTO reporting.dim_restaurants(restaurant_id, restaurant_name, address, postal_code) 
	  select restaurant_id, restaurant_name, address, postal_code
	  from staging.restaurants;
	  
-- dim_salaries
create table if not exists reporting.dim_salaries (
	salary_id INT PRIMARY KEY,
	experience_years INT,
	title_id INT,
	salary_h NUMERIC
);

INSERT INTO reporting.dim_salaries(salary_id, experience_years, title_id, salary_h)
	select s.salary_id, s.experience_years, t.title_id, s.salary_h
	from staging.salaries s
	join reporting.dim_titles t on s.title = t.title;
	
-- dim_cities
create table if not exists staging.cities (
	city TEXT
);

INSERT INTO staging.cities(city)
	select distinct(city) from staging.employees;
	
INSERT INTO staging.cities(city)
	select distinct(city) from staging.restaurants;

create table if not exists reporting.dim_cities (
	city_id SERIAL PRIMARY KEY,
	city TEXT
);

INSERT INTO reporting.dim_cities(city)
	select distinct(city) from staging.cities;
	
select * from reporting.dim_cities;

-- dim_postal_code
drop table if exists staging.postal_code;

create table if not exists staging.postal_code (
	postal_code varchar(10),
	city TEXT
);

INSERT INTO staging.postal_code(postal_code, city)
	select distinct(postal_code), city from staging.employees;
	
INSERT INTO staging.postal_code(postal_code, city)
	select distinct(postal_code), city from staging.restaurants;

create table if not exists reporting.dim_postal_code (
	postal_code VARCHAR(10) PRIMARY KEY,
	city_id INT
);

INSERT INTO reporting.dim_postal_code(postal_code, city_id)
	select distinct(p.postal_code), dc.city_id
	from staging.postal_code p
	join reporting.dim_cities dc on dc.city = p.city;

-- dim_employees
create table if not exists reporting.dim_employees (
	employee_id VARCHAR(4) PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	title_id INT,
	email VARCHAR(50),
	phone_number VARCHAR(15),
	restaurant_id VARCHAR(6),
	address VARCHAR(100),
	postal_code VARCHAR(10),
	experience_years INT,
	salary_id INT
);

INSERT INTO reporting.dim_employees(employee_id, first_name, last_name,
								   title_id, email, phone_number,
								   restaurant_id, address, postal_code,
								   experience_years, salary_id)
	select e.employee_id, e.first_name, e.last_name, 
		   dt.title_id, e.email, e.phone_number, 
		   e.restaurant_id, e.address, e.postal_code, 
		   e.experience_years, e.salary_id
	from staging.employees e
	join reporting.dim_titles dt on dt.title = e.title;


-- fact_employee_shifts
create table if not exists reporting.fact_employee_shifts (
	log_id SERIAL PRIMARY KEY,
	date DATE,
	time TIME,
	activity VARCHAR(3),
	employee_id VARCHAR(4),
	restaurant_id VARCHAR(6)
);

INSERT INTO reporting.fact_employee_shifts(date, time, activity, employee_id, restaurant_id)
	select date, time, activity, employee_id, restaurant_id
	from staging.employee_shifts;












