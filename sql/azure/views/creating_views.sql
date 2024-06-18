/*
--MSSQL
CREATE VIEW EmployeeSalary AS
    WITH WorkDay AS (
        SELECT es.employee_id, 
            CAST(es.timestamp AS DATE) AS date, 
            es.timestamp AS start_time, 
            es2.timestamp AS end_time
        FROM fact_employee_shifts es
        JOIN fact_employee_shifts es2 ON es.employee_id = es2.employee_id
                                    AND CAST(es.timestamp AS DATE) = CAST(es2.timestamp AS DATE)
                                    AND es.activity = 'in'
                                    AND es2.activity = 'out'
    ),                            
    WorkDuration AS (
        SELECT employee_id, 
            start_time, 
            end_time,
            ROUND(DATEDIFF(SECOND, start_time, end_time) / 3600.0, 2) AS hours_worked
        FROM WorkDay
    )

    SELECT  wd.employee_id, 
            de.first_name, 
            de.last_name, 
            dr.restaurant_name,
            FORMAT(wd.start_time, 'MMMM') AS month,
            DATEPART(MONTH, wd.start_time) AS month_no,
            SUM(wd.hours_worked) AS hours_worked,
            ROUND(SUM(wd.hours_worked) * ds.salary_h, 2) AS salary
    FROM WorkDuration wd
    JOIN dim_employees de ON de.employee_id = wd.employee_id
    JOIN dim_restaurants dr ON dr.restaurant_id = de.restaurant_id
    JOIN dim_salaries ds ON ds.salary_id = de.salary_id
    GROUP BY wd.employee_id, de.first_name, de.last_name, dr.restaurant_name, FORMAT(wd.start_time, 'MMMM'), ds.salary_h, DATEPART(MONTH, wd.start_time);
*/

select employee_id, first_name, last_name, restaurant_name, sum(salary) as salary
from EmployeeSalary
where restaurant_name = 'Helsinki Kamppi'
group by employee_id, first_name, last_name, restaurant_name