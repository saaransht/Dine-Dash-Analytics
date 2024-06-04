-- CALCULATING SALES BY RESTAURANT
with ProductsSold as (
	select 	dr.restaurant_name,
			extract(month from fo.timestamp) as month_no,
			to_char(fo.timestamp, 'Month') as month_name,
			dp.product_id, 
			dp.product_name, 
			sum(dod.amount) as num_sold, 
			round(sum(dod.amount) * dpp.price, 2) as sales_euro
	from reporting.dim_restaurants dr
	join reporting.fact_orders fo on fo.restaurant_id = dr.restaurant_id
	join reporting.dim_order_details dod on dod.order_no = fo.order_no
	join reporting.dim_products dp on dp.product_id = dod.product_id
	join reporting.dim_product_price dpp on dpp.price_id = dp.price_id
	group by dr.restaurant_name, dp.product_id, dp.product_name, dpp.price, fo.timestamp
),

RestaurantSales as (
	select restaurant_name, month_no, month_name, sum(sales_euro) as sales
	from ProductsSold
	group by restaurant_name, month_no, month_name
),

-- CALCULATING SALARIES BY RESTAURANT
WorkDay as (
	select 	es.employee_id, 
			es.restaurant_id, 
			date(es.timestamp), 
		   	es.timestamp as start_time, 
		   	es2.timestamp as end_time
	from reporting.fact_employee_shifts es
	join reporting.fact_employee_shifts es2 on es.employee_id = es2.employee_id
										and date(es.timestamp) = date(es2.timestamp)
										and es.activity = 'in'
										and es2.activity = 'out'

),

WorkDuration as (
	select employee_id, restaurant_id, date, start_time, end_time,
			ROUND(EXTRACT(EPOCH FROM(end_time - 
									 start_time)) / 3600, 2)
							   		 AS hours_worked
	from WorkDay
),

Salaries as (
	select 	wd.employee_id, 
		   	dr.restaurant_name, 
			wd.date,
		   	sum(wd.hours_worked) * ds.salary_h as salaries
	from WorkDuration wd
	join reporting.dim_employees de on de.employee_id = wd.employee_id
	join reporting.dim_salaries ds on ds.salary_id = de.salary_id
	join reporting.dim_restaurants dr on dr.restaurant_id = wd.restaurant_id
	group by wd.employee_id, dr.restaurant_name, ds.salary_h, wd.date
),



RestaurantSalaries as (
	select 	restaurant_name, 
			extract(month from date) as month_no, 
			to_char(date, 'Month') as month_name, 
			sum(salaries) as salaries
	from Salaries
	group by restaurant_name, month_no, month_name
),

-- CALCULATING INGREDIENT COST BY RESTAURANT
IngredientAmounts as (
	select ps.restaurant_name, ps.month_no, ps.month_name, ps.product_id, dpi.ingredient_id, dpi.amount_kg * ps.num_sold as total_kg
	from ProductsSold ps
	join reporting.dim_product_ingredients as dpi on dpi.product_id = ps.product_id
),

IngredientCost as (
	select ia.restaurant_name, ia.month_no, ia.month_name, ia.ingredient_id, sum(ia.total_kg) as total_kg, sum(ia.total_kg) * dic.cost_kg as ingredient_cost
	from IngredientAmounts ia
	join reporting.dim_ingredient_cost dic on dic.ingredient_id = ia.ingredient_id
	group by ia.restaurant_name, ia.ingredient_id, dic.cost_kg, ia.month_no, ia.month_name
),

IngredientCostRestaurant as (
	select restaurant_name, month_no, month_name, sum(ingredient_cost) as ingredient_cost
	from IngredientCost
	group by restaurant_name, month_no, month_name
	order by restaurant_name, month_no
)

select 	icr.restaurant_name,
		icr.month_no,
		icr.month_name,
		round(rs.sales, 2) as sales, 
		round(s.salaries, 2) as salaries,
		round(icr.ingredient_cost, 2) as ingredient_cost,
		round(rs.sales - s.salaries - icr.ingredient_cost, 2) as profit
from IngredientCostRestaurant icr
join RestaurantSales rs on rs.restaurant_name = icr.restaurant_name
						and rs.month_no = icr.month_no
join RestaurantSalaries s on s.restaurant_name = rs.restaurant_name
							and s.month_no = rs.month_no;
