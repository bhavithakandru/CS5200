# Part 1:

# load libraries
library(DBI)
library(XML)
library(xml2)
library(RSQLite)
library(dplyr)

# Connect to an SQLite database 
con <- dbConnect(RSQLite::SQLite(), dbname = "pharma_db.sqlite")

# Create 'Products' table
dbExecute(con, "CREATE TABLE IF NOT EXISTS products (
                product_id INTEGER PRIMARY KEY AUTOINCREMENT,
                product_name TEXT NOT NULL,
                description TEXT,
                price REAL)")

# Create 'Reps' table
dbExecute(con, "CREATE TABLE IF NOT EXISTS Reps (
                rep_id INTEGER PRIMARY KEY AUTOINCREMENT,
                firstName TEXT NOT NULL,
                LastName TEXT NOT NULL,
                territory TEXT NOT NULL)")

# Create 'Customers' table
dbExecute(con, "CREATE TABLE IF NOT EXISTS Customers (
                customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
                customer_name TEXT NOT NULL,
                country TEXT NOT NULL)")

# Create 'Sales' table
dbExecute(con, "CREATE TABLE IF NOT EXISTS Sales (
                transaction_id INTEGER PRIMARY KEY AUTOINCREMENT,
                product_id INTEGER,
                rep_id INTEGER,
                customer_id INTEGER,
                quantity INTEGER,
                amount REAL,
                transaction_date TEXT NOT NULL,
                FOREIGN KEY (product_id) REFERENCES Products (product_id),
                FOREIGN KEY (rep_id) REFERENCES Reps (rep_id),
                FOREIGN KEY (customer_id) REFERENCES Customers (customer_id))")

# Load pharmaReps.xml
path <- 'txn-xml/pharmaReps-F23.xml'
xml_reps <- xmlParse(path, useInternalNodes = TRUE)

reps_nodes <- getNodeSet(xml_reps, "//salesteam/rep")
reps_data <- do.call(rbind, lapply(reps_nodes, function(x) {
  rep_id_value <- xmlGetAttr(x, "rID")
  rep_id <- as.integer(substr(rep_id_value, 2, nchar(rep_id_value)))
  first_name <- xmlValue(x[["name"]][["first"]])
  last_name <- xmlValue(x[["name"]][["sur"]])
  territory <- xmlValue(x[["territory"]])
  commission <- as.numeric(xmlValue(x[["commission"]]))
  data.frame(
    rep_id = rep_id,
    firstName = first_name,
    lastName = last_name,
    territory = territory,
    commission = commission,
    stringsAsFactors = FALSE  
  )
}))
#print(head(reps_data))

## Write the reps_data to the reps table in the database
dbWriteTable(con, name = "Reps", value = reps_data, row.names = FALSE, overwrite = TRUE)

#list.files(path = "txn-xml")

# load pharmaSalesTxn-20-F23.xml
txn_path <- 'txn-xml/pharmaSalesTxn-20-F23.xml'
xml_txn <- xmlParse(txn_path)
txn_nodes <- getNodeSet(xml_txn, "//txn")

# Initialize a list to store transaction data
transactions <- list()

# Loop through each transaction node
for (txn_node in txn_nodes) {
  txnID <- as.integer(xmlGetAttr(txn_node, "txnID"))
  repID <- as.integer(xmlGetAttr(txn_node, "repID"))
  
  customer <- as.character(xmlValue(txn_node[["customer"]]))
  country <- as.character(xmlValue(txn_node[["country"]]))
  
  # Access the 'sale' child node
  sale_node <- txn_node[["sale"]]
  
  date <- as.character(xmlValue(sale_node[["date"]]))
  product <- as.character(xmlValue(sale_node[["product"]]))
  qty <- as.integer(xmlValue(sale_node[["qty"]]))
  amount <- as.numeric(xmlSApply(sale_node[["total"]], xmlValue))
  currency <- as.character(xmlGetAttr(sale_node[["total"]], "currency"))
  
  # Append to list
  transactions[[length(transactions) + 1]] <- data.frame(
    TransactionID = txnID, RepID = repID, Customer = customer,
    Country = country, Date = date, Product = product,
    Quantity = qty, Amount = amount, Currency = currency,
    stringsAsFactors = FALSE
  )
}
# Combine all transactions into a single data frame
  txn_data <- do.call(rbind, transactions)
# print(txn_data)

# Iterate through transactions to insert into database

# Customer
  for (i in seq_len(nrow(txn_data))) {
  customerID <- dbGetQuery(con, "SELECT customer_id FROM Customers WHERE customer_name = ? AND country = ?", params = list(txn_data$Customer[i], txn_data$Country[i]))$customer_id
  if (is.na(customerID) || length(customerID) == 0) {
    dbExecute(con, "INSERT INTO Customers (customer_name, country) VALUES (?, ?)", params = list(txn_data$Customer[i], txn_data$Country[i]))
    customerID <- dbGetQuery(con, "SELECT last_insert_rowid() AS id")$id
  }

#Product   
  productID <- dbGetQuery(con, "SELECT product_id FROM products WHERE product_name = ?", params = list(txn_data$Product[i]))$product_id
  if (is.na(productID) || length(productID) == 0) {
    dbExecute(con, "INSERT INTO products (product_name) VALUES (?)", params = list(txn_data$Product[i]))
    productID <- dbGetQuery(con, "SELECT last_insert_rowid() AS id")$id
  }
  dbExecute(con, "INSERT INTO Sales (transaction_date, customer_id, product_id, quantity, amount, rep_id) VALUES (?, ?, ?, ?, ?, ?)",
            params = list(txn_data$Date[i], customerID, productID, txn_data$Quantity[i], txn_data$Amount[i], txn_data$RepID[i]))
}
# Fetch data from con 
reps <- dbGetQuery(con, "SELECT * FROM Reps;")
cust <- dbGetQuery(con, "SELECT * FROM Customers;")
prod <- dbGetQuery(con, "SELECT * FROM products;")
salestxn <- dbGetQuery(con, "SELECT * FROM Sales;")

# Disconnect database
dbDisconnect(con)

print(head(reps, 20))
print(head(cust, 20))
print(head(prod, 20))
print(head(salestxn, 20))
print(tail(salestxn, 20))