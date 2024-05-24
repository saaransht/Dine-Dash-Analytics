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

-- FOREIGN KEYS FOR dim_products
alter table reporting.fact_orders
	add constraint takeaway_id_FK
	foreign key(takeaway_id)
	references reporting.dim_takeaway(takeaway_id);
	

