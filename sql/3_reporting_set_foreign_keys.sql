-- No foreign keys in dim_ingredient_cost

-- FOREIGN KEYS FOR dim_order_details
alter table reporting.dim_order_details
	add constraint order_no_FK
	foreign key(order_no)
	references reporting.fact_orders(order_no);
	
alter table reporting.dim_order_details
	add constraint product_id_FK
	foreign key(product_id)
	references reporting.dim_products(product_id);

-- No foreign keys in dim_product_category

-- FOREIGN KEYS FOR dim_product_ingredients
alter table reporting.dim_product_ingredients
	add constraint ingredient_id_FK
	foreign key(ingredient_id)
	references reporting.dim_ingredient_cost(ingredient_id);
	
alter table reporting.dim_product_ingredients
	add constraint product_id_FK
	foreign key(product_id)
	references reporting.dim_products(product_id);

-- No foreign keys in dim_product_price

-- FOREIGN KEYS FOR dim_products
alter table reporting.dim_products
	add constraint price_id_FK
	foreign key(price_id)
	references reporting.dim_product_price(price_id);
	
alter table reporting.dim_products
	add constraint category_id_FK
	foreign key(category_id)
	references reporting.dim_product_category(category_id);

-- No foreign keys in dim_takeaway

-- -- FOREIGN KEYS FOR dim_products
alter table reporting.fact_orders
	add constraint takeaway_id_FK
	foreign key(takeaway_id)
	references reporting.dim_takeaway(takeaway_id);
	
-- No foreign keys in dim_titles

-- FOREIGN KEYS FOR dim_restaurants
alter table reporting.dim_restaurants
	add constraint restaurants_postal_code_FK
	foreign key(postal_code)
	references reporting.dim_postal_code(postal_code);

-- FOREIGN KEYS FOR dim_salaries
alter table reporting.dim_salaries
	add constraint salaries_title_id_FK
	foreign key(title_id)
	references reporting.dim_titles(title_id);

-- No foreign keys in dim_cities

-- FOREIGN KEYS FOR dim_postal_code
alter table reporting.dim_postal_code
	add constraint city_id_FK
	foreign key(city_id)
	references reporting.dim_cities(city_id);

-- FOREIGN KEYS FOR dim_employees
alter table reporting.dim_employees
	add constraint employees_title_id_FK
	foreign key(title_id)
	references reporting.dim_titles(title_id),
	add constraint employees_restaurant_id_FK
	foreign key(restaurant_id)
	references reporting.dim_restaurants(restaurant_id),
	add constraint employees_postal_code_id_FK
	foreign key(postal_code)
	references reporting.dim_postal_code(postal_code),
	add constraint employees_salary_id_FK
	foreign key(salary_id)
	references reporting.dim_salaries(salary_id);

-- FOREIGN KEYS FOR fact_employee_shifts
alter table reporting.fact_employee_shifts
	add constraint shifts_employee_id_FK
	foreign key(employee_id)
	references reporting.dim_employees(employee_id),
	add constraint shifts_restaurant_id_FK
	foreign key(restaurant_id)
	references reporting.dim_restaurants(restaurant_id);


-- FOREIGN KEYS FOR dim_working_hours
alter table reporting.dim_working_hours
	add constraint working_hours_employee_id_FK
	foreign key(employee_id)
	references reporting.dim_employees(employee_id);
	