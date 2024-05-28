import pandas as pd
import os

DUMMY_DATA_PATH_RAW = os.getcwd() + "/create_dummy_data/data_for_dummy_creation/raw/"

INGREDIENTS_PATH = DUMMY_DATA_PATH_RAW + "ingredients.csv"
INGREDIENTS_COST_PATH = DUMMY_DATA_PATH_RAW + "ingredient_cost.csv"
PRODUCTS_PATH = DUMMY_DATA_PATH_RAW + "products.csv"

def create_dimensions(data_destination, save="no", print_out="no"):
    ingredients = pd.read_csv(INGREDIENTS_PATH)
    products = pd.read_csv(PRODUCTS_PATH)
    ingredient_cost = pd.read_csv(INGREDIENTS_COST_PATH)

    # Transform ingredients to kilograms
    ingredients["amount_kg"] = ingredients["amount"] / 1000

    # Rename columns
    ingredient_cost.rename(columns={"price":"price_kg", "ingredient":"ingredient_name"}, inplace=True)
    # Adding ingredient_id
    ingredient_cost["ingredient_id"] = ingredient_cost.index + 1

    # Create product_ingredients table
    product_ingredients = ingredients
    # Rename & drop columns
    product_ingredients.drop(columns="amount", inplace=True)
    product_ingredients.rename(columns={"ingredient":"ingredient_name"}, inplace=True)

    # Add ingredient_id column to product_ingredients table, drop ingredient_name column
    product_ingredients = pd.merge(product_ingredients, ingredient_cost[["ingredient_name", "ingredient_id"]], on="ingredient_name")
    product_ingredients.drop(columns="ingredient_name")

    # Add product_id column
    products["product_id"] = products.index + 1
    # Rename category column
    products.rename(columns={"category":"category_name"}, inplace=True)

    # Create product_category table
    product_category = pd.DataFrame()
    # Add product categories to table
    categories = products["category_name"].unique()
    product_category["category_name"] = categories
    # Add category_id column
    product_category["category_id"] = product_category.index + 1

    # Add category_id to products table, drop category_name column
    products = pd.merge(products, product_category[["category_name", "category_id"]], on="category_name")
    products.drop(columns="category_name", inplace=True)

    # Create product_price table
    product_price = pd.DataFrame()
    # Add product prices to table
    prices = products["price"].unique()
    product_price["price"] = prices
    # Create price_id column
    product_price["price_id"] = product_price.index + 1

    # Add price_id to product table, drop price column
    products = pd.merge(products, product_price, on="price")
    products.drop(columns="price", inplace=True)
    # Create product_id column
    products["product_id"] = products.index + 1

    # Add product_id to product_ingredients table, drop product_name & ingredient_name columns
    product_ingredients = pd.merge(product_ingredients, products[["product_name", "product_id"]], on="product_name")
    product_ingredients.drop(columns=["product_name", "ingredient_name"], inplace=True)
    # Create recipe_id column
    product_ingredients["recipe_id"] = product_ingredients.index + 1

    if print_out == "yes":
        print("DIM_INGREDIENT_COST\n", ingredient_cost, "\n\n",
              "DIM_PRODUCT_INGREDIENTS\n", product_ingredients, "\n\n",
              "DIM_PRODUCT_CATEGORY\n", product_category, "\n\n",
              "DIM_PRODUCT_PRICE\n", product_price, "\n\n"
              )
    else:
        pass

    if save == "no":
        pass
    elif save == "yes":
        # Save dimensions
        ingredient_cost.to_csv(data_destination + "ingredient_cost.csv", index=False)
        product_ingredients.to_csv(data_destination + "product_ingredients.csv", index=False)
        products.to_csv(data_destination + "products.csv", index=False)
        product_category.to_csv(data_destination + "product_category.csv", index=False)
        product_price.to_csv(data_destination + "product_price.csv", index=False)
    else:
        pass