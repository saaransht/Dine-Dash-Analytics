create table analysis.working_hours_salaries (
    date DATE,
    employee_id VARCHAR(4),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    title VARCHAR(50),
    restaurant_name VARCHAR(50),
    hours_worked NUMERIC(38,6),
    salary_euro NUMERIC(38,6)
)

insert into analysis.working_hours_salaries
    select 
        date,  
        employee_id,
        first_name,
        last_name,
        title,
        restaurant_name,
        hours_worked,
        salary_euro
    from 
        EmployeeHoursSalaryDaily

-- select * from analysis.working_hours_salaries