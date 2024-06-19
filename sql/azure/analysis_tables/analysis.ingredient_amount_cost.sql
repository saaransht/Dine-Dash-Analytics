create table analysis.ingredient_amount_cost (
    date DATE,
    restaurant_name VARCHAR(50),
    ingredient_name VARCHAR(50),
    amount_kg DECIMAL(38,3),
    cost_euro DECIMAL(38,3)
)

insert into analysis.ingredient_amount_cost
    select 
        date,
        restaurant_name,
        ingredient_name,
        amount_kg,
        cost
    from 
        IngredientAmountCostDaily

-- select * from analysis.ingredient_amount_cost