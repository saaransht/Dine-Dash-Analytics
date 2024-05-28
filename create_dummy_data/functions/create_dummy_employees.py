import pandas as pd
from faker import Faker
from random import choice
import os

CURR_DIR = os.getcwd()

SALARIES_PATH = CURR_DIR + "/create_dummy_data/data_for_dummy_creation/raw/salaries.csv"
EXPERIENCE_PATH = CURR_DIR + "/create_dummy_data/data_for_dummy_creation/raw/employee_experience.csv"

DATA_DEST = CURR_DIR + "/data/clean/"

def get_employees():
    cook = pd.read_csv("/Users/joonas/VSCode/Restaurant Sales Analysis/create_dummy_data/data_for_dummy_creation/raw/cook_shifts.csv")
    waiter = pd.read_csv("/Users/joonas/VSCode/Restaurant Sales Analysis/create_dummy_data/data_for_dummy_creation/raw/waiter_shifts.csv")

    waiter.drop(columns="day_no", inplace=True)
    employees_df = pd.concat([cook, waiter], axis=1)
    employees = employees_df.columns[1:]

    return employees, employees_df

def get_dates():
    get_dates = pd.read_csv("/Users/joonas/VSCode/Restaurant Sales Analysis/data/clean/orders_HKI001.csv")

    timestamps = pd.DataFrame()
    timestamps["timestamp"] = get_dates["timestamp"]
    timestamps = timestamps["timestamp"].str.split(" ", expand=True)

    date_list = timestamps[0].unique()

    return date_list

def create_shifts(restaurant_id):
    date_list = get_dates()
    employees, employees_df = get_employees()

    shifts_df = pd.DataFrame()

    for employee in employees:
        shift_pattern = list(employees_df[employee])
        shifts = [shift_pattern[i % len(shift_pattern)] for i in range(len(date_list))]

        employee_shifts = pd.DataFrame()
        employee_shifts["date"] = date_list
        employee_shifts["shift"] = shifts
        employee_shifts["employee"] = employee

        shifts_df = pd.concat([shifts_df, employee_shifts], axis=0)

    # Remove null rows
    shifts_df = shifts_df[~shifts_df["shift"].isnull()]

    # Split start-end
    shifts_df[["start", "end"]] = shifts_df["shift"].str.split("-", expand=True)

    # Create final shifts
    shift_start = shifts_df.drop(columns=["shift", "end"])
    shift_start.rename(columns={"start":"hour"}, inplace=True)
    shift_start["activity"] = "in"
    shift_end = shifts_df.drop(columns=["shift", "start"])
    shift_end.rename(columns={"end":"hour"}, inplace=True)
    shift_end["activity"] = "out"

    final_shifts = pd.concat([shift_start, shift_end], axis=0)
    final_shifts["time"] = pd.to_datetime(final_shifts["hour"], format="%H:%M").dt.strftime("%H:%M")
    final_shifts["restaurant_id"] = restaurant_id

    return final_shifts

def create_employee_details(restaurant_id):
    employees, df = get_employees()
    
    create = Faker()

    num_employees = 30
    phone_number_numbers = ["0","1","2","3","4","5","6","7","8","9"]
    phone_number_start = "+44 44 "
    employee_details = []

    for _ in range(num_employees):
        first_name = create.first_name()
        last_name = create.last_name()

        address = create.address()
        street_address = create.street_address()
        city = create.city()
        postal_code = create.postalcode()

        email = f"{first_name}@{last_name}.net".lower()

        phone_number = phone_number_start
        for _ in range(7):
            next = choice(phone_number_numbers)
            phone_number = phone_number + next

        curr_employee = [first_name, last_name, street_address, city, postal_code, email, phone_number]
        employee_details.append(curr_employee)

    employee_df = pd.DataFrame(employee_details, columns=["first_name", "last_name", 
                                                          "street_address", "city", 
                                                          "postal_code", "email", 
                                                          "phone_number"])
    
    employee_df["employee"] = employees

    titles = []
    for i in range(len(employees)):
        title = employees[i].split("-")[0].title()
        titles.append(title)

    employee_df["title"] = titles
    employee_df["restaurant_id"] = restaurant_id

    return employee_df

def add_experience(employee_details):
    experience = pd.read_csv(EXPERIENCE_PATH)
    employee_details = pd.merge(employee_details, experience, on="employee_id")

    return employee_details

def add_salary(employee_details):
    salaries = pd.read_csv(SALARIES_PATH)
    employee_details = pd.merge(employee_details, salaries[["title", "experience_years", "salary_id"]],
                                on=["experience_years", "title"])

    return employee_details

def create_restaurant_employees(restaurants_dict, print_out="no", save="no"):
    employee_details = pd.DataFrame()

    for i in list(restaurants_dict.keys()):
        restaurant_id = restaurants_dict[i]["id"]

        employee_details_restaurant = create_employee_details(restaurant_id)

        employee_details = pd.concat([employee_details, employee_details_restaurant], axis=0)

    employee_details.reset_index(drop=True, inplace=True)
    employee_details["employee_id"] = employee_details.index + 1
    employee_details = add_experience(employee_details)
    employee_details["employee_id"] = employee_details["employee_id"].astype(str).str.zfill(4)
    employee_details = add_salary(employee_details)

    # Print DataFrame
    if print_out == "yes":
        print("EMPLOYEE DETAILS:\n", employee_details, "\n\n")
    else:
        pass

    # Save DataFrame
    if save == "yes":
        employee_details.to_csv(DATA_DEST + "employee_details.csv", index=False)
    else:
        pass

    return employee_details

def create_employee_shifts(restaurants_dict, employee_details, print_out="no", save="no"):
    employee_shifts = pd.DataFrame()

    # Create shifts
    for i in list(restaurants_dict.keys()):
        restaurant_id = restaurants_dict[i]["id"]

        employee_shifts_restaurant = create_shifts(restaurant_id)

        employee_shifts = pd.concat([employee_shifts, employee_shifts_restaurant], axis=0)

    employee_shifts.reset_index(drop=True, inplace=True)
    employee_shifts = pd.merge(employee_shifts, employee_details[["employee", "restaurant_id", "employee_id"]], on=["employee", "restaurant_id"])
    employee_shifts = employee_shifts.sort_values(by=["date", "time"], ascending=True)
    employee_shifts.drop(columns=["employee", "hour"], inplace=True)

    if print_out == "yes":
        print("EMPLOYEE SHIFTS:\n", employee_shifts, "\n\n")
    else:
        pass

    if save == "yes":
        employee_shifts.to_csv(DATA_DEST + "employee_shifts.csv", index=False)