import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from create_dummy_data.functions.create_dummy_orders import generate_restaurant_orders
from create_dummy_data.functions.create_dimensions import create_dimensions
from create_dummy_data.functions.create_dummy_employees import *

CURR_DIR_PATH = os.getcwd()
DATA_DEST = CURR_DIR_PATH + "/data/clean/"

""" Define parameters for dummy order data """
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

# # Parameters: Year, number of orders weekly, variance for number of orders
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

""" Create & save dimension tables """
create_dimensions(data_destination=DATA_DEST, save="no", print_out="no")

""" Generate restaurant order data """
generate_restaurant_orders(restaurants, year, variance, daily_traffic_distribution, \
                           time_of_day_distribution, time_ranges, save="no", print_out="no")

""" Create restaurant employees & shifts """
employee_details = create_restaurant_employees(restaurants)
print("EMPLOYEE DETAILS")
print(employee_details)
print()

employee_shifts = create_employee_shifts(restaurants, employee_details)
print("EMPLOYEE SHIFTS")
print(employee_shifts)
print()