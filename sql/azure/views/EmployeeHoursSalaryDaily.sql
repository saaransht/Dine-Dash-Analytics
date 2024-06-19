CREATE VIEW EmployeeHoursSalaryDaily AS
with EmployeeDetails AS (
    select de.employee_id,
            de.first_name,
            de.last_name,
            dt.title,
            ds.salary_h
    from dim_employees de
    join dim_titles dt on dt.title_id = de.title_id
    join dim_salaries ds on ds.salary_id = de.salary_id
),
EmployeeTimeLog AS (
select fes.employee_id,
        fes.restaurant_id,
        CAST(fes.timestamp AS DATE) AS date,
        fes.timestamp as start_time,
        fes2.timestamp as end_time
from fact_employee_shifts fes
join fact_employee_shifts fes2 on fes.employee_id = fes2.employee_id
                                and cast(fes2.timestamp as date) = cast(fes.timestamp as date)
                                and fes.activity = 'in'
                                and fes2.activity = 'out'
),
WorkingHours AS (
    select etl.employee_id,
            dr.restaurant_name,
            etl.date,
            datediff(minute, etl.start_time, etl.end_time) / 60.0 as hours_worked
    from EmployeeTimeLog etl
    join dim_restaurants dr on dr.restaurant_id = etl.restaurant_id
)
select  wh.date,
        ed.employee_id,
        ed.first_name,
        ed.last_name,
        ed.title,
        wh.restaurant_name,
        sum(wh.hours_worked) as hours_worked,
        sum(wh.hours_worked) * salary_h as salary_euro
from EmployeeDetails ed
join WorkingHours wh on wh.employee_id = ed.employee_id
group by wh.date, ed.employee_id, ed.first_name, ed.last_name, ed.title, wh.restaurant_name, salary_h


-- MONTHLY SALARY
-- select 
--     format(date, 'MMMM'),
--     employee_id,
--     first_name,
--     last_name,
--     title,
--     restaurant_name,
--     sum(hours_worked),
--     sum(salary_euro)
-- from EmployeeHoursSalaryDaily
-- where employee_id = '0010'
-- group by
--     format(date, 'MMMM'),
--     employee_id,
--     first_name,
--     last_name,
--     title,
--     restaurant_name