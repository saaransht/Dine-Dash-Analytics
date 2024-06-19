create table analysis.orders_hourly (
    date DATE,
    hour INT,
    restaurant_name VARCHAR(50),
    num_orders INT
);

insert into analysis.orders_hourly
    select
        cast(fo.timestamp as date) as date,
        datepart(hour, fo.timestamp) as hour,
        dr.restaurant_name,
        count(fo.order_no) as num_orders
    from 
        fact_orders fo
    join 
        dim_restaurants dr
        on dr.restaurant_id = fo.restaurant_id
    group by
        cast(fo.timestamp as date),
        datepart(hour, fo.timestamp),
        dr.restaurant_name
    order by
        dr.restaurant_name,
        cast(fo.timestamp as date),
        datepart(hour, fo.timestamp);

select top (100) * from analysis.orders_hourly
order by
    restaurant_name,
    date,
    hour;