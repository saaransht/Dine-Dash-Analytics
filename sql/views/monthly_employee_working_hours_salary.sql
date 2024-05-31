with WorkDay as (
	select es.employee_id, date(es.timestamp), 
		   es.timestamp as start_time, 
		   es2.timestamp as end_time
	from reporting.fact_employee_shifts es
	join reporting.fact_employee_shifts es2 on es.employee_id = es2.employee_id
										and date(es.timestamp) = date(es2.timestamp)
										and es.activity = 'in'
										and es2.activity = 'out'

),							
WorkDuration as (
	select employee_id, start_time, end_time,
			ROUND(EXTRACT(EPOCH FROM(end_time - 
									 start_time)) / 3600, 2)
							   AS hours_worked
	from WorkDay
)

select 	wd.employee_id, 
		de.first_name, 
		de.last_name, 
		dr.restaurant_name,
		to_char(wd.start_time::date, 'Month') as month,
		extract(month from wd.start_time) as month_no,
		sum(wd.hours_worked) as hours_worked,
		round(sum(wd.hours_worked) * ds.salary_h, 2) as salary
from WorkDuration wd
join reporting.dim_employees de on de.employee_id = wd.employee_id
join reporting.dim_restaurants dr on dr.restaurant_id = de.restaurant_id
join reporting.dim_salaries ds on ds.salary_id = de.salary_id
group by wd.employee_id, de.first_name, de.last_name, dr.restaurant_name, month, ds.salary_h, month_no
order by month_no, dr.restaurant_name, wd.employee_id;