import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from create_dummy_data.functions.create_dummy import *
from create_dummy_data.functions.create_dimensions import create_dimensions

CURR_DIR_PATH = os.getcwd()
DATA_DEST = CURR_DIR_PATH + "/data/clean/"


""" Create & save dimension tables """
from create_dummy_data.functions.create_dimensions import create_dimensions
create_dimensions(data_destination=DATA_DEST)


""" Define parameters for dummy data, generate (& save) dummy orders """
# Define traffic distribution by day of the week
daily_traffic_distribution = {
    "Monday": 0.10,
    "Tuesday": 0.12,
    "Wednesday": 0.14,
    "Thursday": 0.16,
    "Friday": 0.20,
    "Saturday": 0.18,
    "Sunday": 0.10
}

# Define traffic distribution by time of day
time_of_day_distribution = {
    "Lunch": 0.25,
    "Afternoon": 0.20,
    "Dinner": 0.55
}

# Define time ranges for each period
time_ranges = {
    "Lunch": ("11:00", "13:00"),
    "Afternoon": ("13:00", "18:00"),
    "Dinner": ("18:00", "23:00")
}

# Parameters: Year, number of orders weekly, variance for number of orders
year = 2023
base_weekly_orders = 500
variance = 0.20

# Restaurant parameters
restaurants = {
    1:{"id":"HKI001",
     "city":"Helsinki",
     "weekly_orders":base_weekly_orders * 1},
    2:{"id":"HKI002",
     "city":"Helsinki",
     "weekly_orders":base_weekly_orders * 0.95},
    3:{"id":"HKI003",
     "city":"Helsinki",
     "weekly_orders":base_weekly_orders * 0.90},
    4:{"id":"TKU001",
     "city":"Turku",
     "weekly_orders":base_weekly_orders * 0.80},
    5:{"id":"TKU002",
     "city":"Turku",
     "weekly_orders":base_weekly_orders * 0.90},
    6:{"id":"TRE001",
     "city":"Tampere",
     "weekly_orders":base_weekly_orders * 0.90},
    7:{"id":"TRE002",
     "city":"Tampere",
     "weekly_orders":base_weekly_orders * 0.95},
    8:{"id":"OUL001",
     "city":"Oulu",
     "weekly_orders":base_weekly_orders * 0.75},
}

order_no = 0  # Tracking the order number to not create duplicate order numbers for the restaurants

# Generate dummy orders for restaurants
for i in list(restaurants.keys()):
    weekly_orders = restaurants[i]["weekly_orders"]
    restaurant_id = restaurants[i]["id"]

    # Generate the timestamps data
    timestamps = generate_yearly_order_data(year, base_weekly_orders, variance, daily_traffic_distribution, time_of_day_distribution, time_ranges)

    # Add order numbers
    orders_df, order_no = add_order_no(timestamps, order_no)

    # Generate takeaway data
    orders_df = generate_takeaway(orders_df)

    # Add restaurant_id
    orders_df.loc[:, "restaurant_id"] = restaurant_id

    # Format timestamp
    orders_df = format_timestamp(orders_df)

    order_details_df = generate_sales_data(len(orders_df), orders_df["order_no"].iloc[0])

    orders_df = generate_order_no(orders_df)
    order_details_df = generate_order_no(order_details_df)

    # # Save the generated order data
    # orders_df.to_csv(DATA_DEST + "orders_" + restaurant_id + ".csv", index=False)
    # order_details_df.to_csv(DATA_DEST + "order_details_" + restaurant_id + ".csv", index=False)

    print()
    print()
    print(restaurant_id)
    print(orders_df)
    print(order_details_df)
    print()
    print()

