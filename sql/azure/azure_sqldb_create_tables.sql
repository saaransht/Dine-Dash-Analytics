drop table 	[dbo].[dim_restaurants],
			[dbo].[dim_order_details],
			[dbo].[dim_employees],
			[dbo].[dim_salaries],
			[dbo].[dim_takeaway],
			[dbo].[dim_titles],
			[dbo].[fact_orders],
			[dbo].[fact_employee_shifts],
			[dbo].[dim_ingredient_cost],
			[dbo].[dim_product_category],
			[dbo].[dim_product_ingredients],
			[dbo].[dim_product_price],
			[dbo].[dim_products];

create table dim_employees (
	employee_id VARCHAR(4) PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	title_id INT,
	email VARCHAR(100),
	phone_number VARCHAR(20),
	restaurant_id VARCHAR(6),
	address VARCHAR(100),
	postal_code VARCHAR(8),
	experience_years INT,
	salary_id INT
);

create table dim_order_details (
	order_no VARCHAR(7),
	product_id INT,
	amount INT,
	row_id INT PRIMARY KEY
);

create table dim_restaurants (
	restaurant_id VARCHAR(6) PRIMARY KEY,
	restaurant_name VARCHAR(50),
	address VARCHAR(100),
	postal_code VARCHAR(10)
);

create table dim_salaries (
	salary_id INT PRIMARY KEY,
	experience_years INT,
	title_id INT,
	salary_h DECIMAL(4,2)
);

create table dim_takeaway (
	takeaway_id INT PRIMARY KEY,
	takeaway VARCHAR(50)
);

create table dim_titles (
	title_id INT PRIMARY KEY,
	title VARCHAR(50)
);

create table fact_orders (
	timestamp DATETIME,
	order_no VARCHAR(7) PRIMARY KEY,
	takeaway_id INT,
	restaurant_id VARCHAR(6)
);

create table fact_employee_shifts (
	log_id INT PRIMARY KEY,
	timestamp DATETIME,
	activity VARCHAR(3),
	employee_id VARCHAR(4),
	restaurant_id VARCHAR(6)
);

create table dim_ingredient_cost (
	ingredient_name VARCHAR(50),
	cost_kg DECIMAL(8,2),
	ingredient_id INT PRIMARY KEY
);

create table dim_product_category (
	category_name VARCHAR(50),
	category_id INT PRIMARY KEY
);

create table dim_product_ingredients (
	amount_kg DECIMAL(8,3),
	ingredient_id INT,
	product_id INT,
	recipe_id INT PRIMARY KEY
);

create table dim_product_price (
	price DECIMAL(8,2),
	price_id INT PRIMARY KEY
);

create table dim_products (
	product_name VARCHAR(50),
	product_id INT PRIMARY KEY,
	category_id INT,
	price_id INT
);

/*

select * from [dbo].[dim_employees];
select * from [dbo].[dim_order_details];
select * from [dbo].[dim_restaurants];
select * from [dbo].[dim_salaries];


*/

select * from [dbo].[dim_salaries]
where salary_h = 19.15;

select column_name, data_type from information_schema.columns
where table_schema = 'dbo'
	and table_name = 'dim_salaries';
