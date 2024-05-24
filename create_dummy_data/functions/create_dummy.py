import pandas as pd
import random
from datetime import datetime, timedelta
import os

CURR_DIR_PATH = os.getcwd()
PRODUCT_POPULARITY_PATH = CURR_DIR_PATH + "/create_dummy_data/data_for_dummy_creation/raw/product_popularity.csv"

# Generate realistic timestamps for orders
def generate_timestamps(day, num_orders, time_dist, time_ranges):
    timestamps = []
    for period, proportion in time_dist.items():
        num_period_orders = int(num_orders * proportion)
        start_time, end_time = time_ranges[period]
        start_dt = datetime.strptime(f"{day} {start_time}", "%Y-%m-%d %H:%M")
        end_dt = datetime.strptime(f"{day} {end_time}", "%Y-%m-%d %H:%M")
        for _ in range(num_period_orders):
            random_time = start_dt + (end_dt - start_dt) * random.random()
            timestamps.append(random_time.strftime("%Y-%m-%d %H:%M"))
    return timestamps

# Generate order timestamps for the entire year
def generate_yearly_order_data(year, base_weekly_orders, variance, daily_traffic_dist, time_of_day_dist, time_ranges):
    timestamps = []
    start_date = datetime(year, 1, 1)
    end_date = datetime(year, 12, 31)
    current_date = start_date
    
    while current_date <= end_date:
        week_number = current_date.isocalendar()[1]
        num_orders = base_weekly_orders + int(base_weekly_orders * (random.uniform(-variance, variance)))
        for day, day_proportion in daily_traffic_dist.items():
            day_str = (current_date + timedelta(days=list(daily_traffic_dist.keys()).index(day))).strftime("%Y-%m-%d")
            num_day_orders = int(num_orders * day_proportion)
            day_timestamps = generate_timestamps(day_str, num_day_orders, time_of_day_dist, time_ranges)
            timestamps.extend(day_timestamps)
        current_date += timedelta(weeks=1)
    
    return timestamps

# Add order number
def add_order_no(df, order_no):
    # Convert to DataFrame and sort by timestamps
    orders_df = pd.DataFrame(df, columns=["timestamp"])
    orders_df["timestamp"] = pd.to_datetime(orders_df["timestamp"])
    orders_df = orders_df.sort_values(by="timestamp").reset_index(drop=True)
    # orders_df["timestamp"] = orders_df["timestamp"].dt.strftime("%Y-%m-%d %H:%M")

    # Add order numbers after sorting
    # orders_df["order_no"] = orders_df.index + 1
    orders_df["order_no"] = (orders_df.index + 1) + order_no

    order_no = orders_df["order_no"].iloc[-1]

    # Display the DataFrame
    # print(orders_df)
    return orders_df, order_no

def generate_order_no(df):
    # Create sequential 7-digit order numbers
    # df['order_no'] = (df.index + 1).astype(str).str.zfill(7)
    df['order_no'] = df["order_no"].astype(str).str.zfill(7)

    return df

# Format timestamp
def format_timestamp(df):
    df["timestamp"] = df["timestamp"].dt.strftime("%Y-%m-%d %H:%M")

    return df


""" Generating takeaway data """
# Function to generate the takeaway column based on specified distribution and variance
def generate_takeaway_data_monthly(df):
    # Initialize an empty list to store the takeaway values
    takeaway_values = []
    
    # Iterate over each row in the DataFrame
    for index, row in df.iterrows():
        # Extract month from the timestamp
        month = row['timestamp'].month
        
        # Define distribution for the current month (with variance)
        dine_in_percent = random.uniform(0.75, 0.90)
        takeaway_percent = random.uniform(0.01, 0.03)
        delivery_percent = 1 - dine_in_percent - takeaway_percent
        
        # Generate a random number to determine the takeaway type
        rand_num = random.random()
        
        # Determine the takeaway type based on the random number
        if rand_num <= dine_in_percent:
            takeaway_values.append('dine-in')
        elif dine_in_percent < rand_num <= (dine_in_percent + takeaway_percent):
            takeaway_values.append('takeaway')
        else:
            # Randomly choose one of the delivery services
            delivery_services = ['Foodora', 'Wolt', 'UberEats']
            delivery_service = random.choice(delivery_services)
            takeaway_values.append(delivery_service)
    
    # Add the takeaway column to the DataFrame
    df_copy = df.copy()
    df_copy.loc[:, 'takeaway'] = takeaway_values
    
    return df_copy

def generate_takeaway(df):
    # Generate the takeaway column separately for each month
    for month in range(1, 13):
        # Filter the DataFrame for the current month
        df_month = df[df['timestamp'].dt.month == month]
        
        # Generate the takeaway column for the current month
        df_month = generate_takeaway_data_monthly(df_month)
        
        # Update the original DataFrame with the generated values for the current month
        df.loc[df['timestamp'].dt.month == month, 'takeaway'] = df_month['takeaway']

    return df


""" Generating order details (products ordered, amounts)"""
def get_popularity():
    popular = pd.read_csv(PRODUCT_POPULARITY_PATH)

    popular_dict = {}

    for category in popular["category"].unique():
        cat = category
        cat_df = popular[popular["category"] == cat]

        cat_items = list(cat_df["product_name"])
        cat_popular = list(cat_df["popular"])

        cat_dict = dict(zip(cat_items, cat_popular))
        cat_dict = {cat:cat_dict}

        popular_dict.update(cat_dict)

    return popular_dict

# Function to randomly select menu item based on weights
def select_item(category, popularity):
    items = list(popularity[category].keys())
    weights = list(popularity[category].values())
    return random.choices(items, weights=weights)[0]

# Generate dummy sales data
def generate_sales_data(num_orders, order_no):
    popularity = get_popularity()

    transactions = []
    for order_number in range(order_no, order_no + num_orders):
        num_pizzas = random.randint(1, 6)
        num_appetisers = random.randint(0, min(num_pizzas, len(popularity["appetiser"])))
        num_desserts = random.randint(0, min(num_pizzas, len(popularity["dessert"])))
        
        if random.random() < 0.35:  # 35% chance of ordering appetisers
            if num_appetisers == 0 and random.random() < 0.15:  # 15% chance of ordering dessert if no appetiser
                num_desserts += 1
        
        pizzas = [select_item("pizza", popularity) for _ in range(num_pizzas)]
        appetisers = [select_item("appetiser", popularity) for _ in range(num_appetisers)]
        desserts = [select_item("dessert", popularity) for _ in range(num_desserts)]
        
        items = pizzas + appetisers + desserts
        for item in items:
            transactions.append({"order_no": order_number, "product_name": item})
    
    df = pd.DataFrame(transactions)
    df = df.groupby(["order_no", "product_name"]).size().reset_index(name="amount")

    return df