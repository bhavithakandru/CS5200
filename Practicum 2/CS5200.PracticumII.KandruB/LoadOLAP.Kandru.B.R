# Part 2

# 1. Library
library(DBI)
library(RSQLite)
library(RMySQL)

# 2. Settings freemysqlhosting.net (max 5MB)
conn <- dbConnect(RMySQL::MySQL(), 
                        host = "sql5.freemysqlhosting.net", 
                        user = "sql5698877", 
                        password ="SkexLkK9Kt",
                        dbname = "sql5698877",
                        db_port = 3306)
# Connect to SQLite database
sql_con <- dbConnect(RSQLite::SQLite(), "pharma_db.sqlite")

# Create product_facts
dbExecute(conn, "DROP TABLE IF EXISTS product_facts")
dbExecute(conn, "
CREATE TABLE product_facts (
    product_id INTEGER,
    product_name TEXT NOT NULL,
    total_sales INTEGER,
    year INTEGER,
    quantity INTEGER,
    quarter_year INTEGER,
    region VARCHAR(255) NOT NULL,
    units_per_region INTEGER,
    PRIMARY KEY(product_id, year, quarter_year, region)
)
")

# Create rep_facts
dbExecute(conn, "DROP TABLE IF EXISTS rep_facts")
dbExecute(conn, "
CREATE TABLE rep_facts (
    rep_id INTEGER,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    region VARCHAR(255) NOT NULL,
    year INTEGER,
    total_sales INTEGER,
    average_amount_sold INTEGER,
    product_id INTEGER,
    quarter_year INTEGER,
    PRIMARY KEY(rep_id, year, quarter_year, product_id)
)
")

# Query to aggregate product data
product_query <- "
  SELECT p.product_id, p.product_name,s.quantity,SUM(s.amount) AS total_sales,
         substr(s.transaction_date, -4) AS year,
         CASE 
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 1 AND 3 THEN 1
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 4 AND 6 THEN 2
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 7 AND 9 THEN 3
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 10 AND 12 THEN 4
         END AS quarter_year,
         r.territory AS region
  FROM Sales s
  JOIN products p ON s.product_id = p.product_id
  JOIN reps r ON s.rep_id = r.rep_id
  GROUP BY p.product_id, year, quarter_year, r.territory
"

# Fetch data from SQLite
product_facts <- dbGetQuery(sql_con, product_query)

#print(product_facts)

# Insert data into MySQL
dbWriteTable(conn, "product_facts", product_facts, append = TRUE, row.names = FALSE)

# Query to aggregate sales rep data
rep_query <- "
  SELECT r.rep_id, r.firstName,r.lastName,r.territory AS region, SUM(s.amount) AS total_sales,
  substr(s.transaction_date, -4) AS year,
         CASE 
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 1 AND 3 THEN 1
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 4 AND 6 THEN 2
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 7 AND 9 THEN 3
           WHEN CAST(substr(s.transaction_date, 1, instr(s.transaction_date, '/') - 1) AS INTEGER) BETWEEN 10 AND 12 THEN 4
         END AS quarter_year,
         p.product_id
  FROM Sales s
  JOIN reps r ON s.rep_id = r.rep_id
  JOIN products p ON s.product_id = p.product_id
  GROUP BY r.rep_id, year, quarter_year, p.product_id
"
# Fetch data from SQLite
rep_facts <- dbGetQuery(sql_con, rep_query)

# Insert data into MySQL
dbWriteTable(conn, "rep_facts", rep_facts, append = TRUE, row.names = FALSE)

reps <- dbGetQuery(conn, "SELECT * FROM rep_facts;")
prod <- dbGetQuery(conn, "SELECT * FROM product_facts;")

print(reps, 20)
print(prod, 20)
print(tail(reps, 10))
print(tail(prod, 10))

## What is the total sold for each quarter of 2021 for 'Alaraphosol'?
alaraphosol_query <- "
  SELECT quarter_year, SUM(total_sales) AS totalSales
  FROM product_facts
  WHERE year = 2021 AND product_name = 'Alaraphosol'
  GROUP BY quarter_year;
"
alaraphosol <- dbGetQuery(conn, alaraphosol_query)
print(alaraphosol)

## Which sales rep sold the most in 2022?
most_sale_query <- "
  SELECT rep_id, firstName, lastName, SUM(total_sales) AS totalSales
  FROM rep_facts
  WHERE year = 2022
  GROUP BY rep_id, firstName, lastName
  ORDER BY total_sales DESC
  LIMIT 1;
"
most_sale <- dbGetQuery(conn, most_sale_query)
print(most_sale)

## How many units were sold in EMEA in 2022 for 'Alaraphosol'?
total_Query <- "
SELECT SUM(quantity) AS units_sold
FROM product_facts
WHERE product_name = 'Alaraphosol'
  AND region = 'EMEA'
  AND year = 2022;
"
total <- dbGetQuery(conn,total_Query)
print(total)

#Disconnect from all databases
dbDisconnect(conn)
dbDisconnect(sql_con)