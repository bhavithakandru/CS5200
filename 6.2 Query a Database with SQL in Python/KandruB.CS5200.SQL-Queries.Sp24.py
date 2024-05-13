#!/usr/bin/Python
# title: ASSIGNMENT 06.2: Query a Database with SQL in Python
# name: Bhavitha Naga Sai Kandru
# date: Spring2024

import sqlite3
import pandas as pd

# 1)Connect to the SQLite database
dbcon = sqlite3.connect('MediaDB.db')
cursor = dbcon.cursor()

# 2)Query for the last name, first name, title, and hire date of all employees, sorted by last name
query = "SELECT LastName, FirstName, Title, HireDate FROM employees ORDER BY LastName"
employees = pd.read_sql_query(query, dbcon)
print(employees)

# 3)Query for the total number of bytes for all tracks
cursor.execute("SELECT SUM(Bytes) FROM tracks")
total_bytes = cursor.fetchone()[0]
print("\nTotal number of bytes for all tracks:", total_bytes)

# 4)Query to display all of the genres
cursor.execute("SELECT Name FROM genres")
genres = cursor.fetchall()
print("\nList of all genres:")
for genre in genres:
    print(genre[0])

# 5)Close the connection to the database
dbcon.close()