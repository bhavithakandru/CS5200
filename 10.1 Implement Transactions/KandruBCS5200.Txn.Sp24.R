# Importing necessary libraries
library(RMariaDB)
library(dplyr)
library(DBI)
library(readr)

# Question 1:

# Database settings
db_name <- "sql5690911"
db_user <- "sql5690911"
db_host <- "sql5.freemysqlhosting.net"
db_pwd <- "6vXhYueYTL"
db_port <- 3306

# Establishing a connection to the database
con <- dbConnect(RMariaDB::MariaDB(), user = db_user, password = db_pwd, dbname = db_name, host = db_host, port = db_port)

#Question 2:

# Create a new DataFrame for ten new bird strike incidents
bird_strikes_1 <- data.frame(
  rid = 1:10,
  aircraft = c("Airplane","Airplane","Airplane","Airplane","Airplane","Airplane","Airplane","Airplane","Airplane","Airplane"),
  airport = c("JFK International", "LAX", "O'Hare International", "Heathrow", "Charles de Gaulle", "Rajiv Gandhi International", "logan International", "San Francisco International", "Denver International", "Miami International"),
  model = c("A320", "B737-800", "B747", "A380", "B787", "A320", "B737", "A330", "B777", "A350"),
  impact = c("None", "Engine Shut Down", "None", "None", "Precautionary Landing", "None", "None", "Engine Shut Down", "None", "None"),
  flight_date = c("2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00","2023-03-15 0:00"),
  damage = c("No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "No damage"),
  airline = c("Delta Airlines", "United Airlines", "American Airlines", "British Airways", "Air France", "New Indigo", "spirit", "United Airlines", "Delta Airlines", "American Airlines"),
  origin = c("New York", "California", "Illinois", "United Kingdom", "France", "Telangana", "Massachusetts", "California", "Colorado", "Florida"),
  flight_phase = c("Approach", "Climb", "Approach", "Climb", "Approach", "Approach", "Climb", "Climb", "Approach", "Climb"),
  wildlife_size = c("Small", "Medium", "Small", "Medium", "Large", "Small", "Medium", "Large", "Small", "Medium"),
  sky_conditions = c("No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud"),
  pilot_warned_flag = c("N", "Y", "N", "N", "Y", "N", "N", "Y", "N", "N"),
  altitude_ft = c(200, 1500, 100, 2000, 500, 300, 1500, 2000, 100, 500),
  heavy_flag = c("No", "Yes", "No", "No", "Yes", "No", "No", "Yes", "No", "No")
)
write.csv(bird_strikes_1, "bird_strikes_1.csv", row.names = FALSE)

bird_strikes_2 <- data.frame(
  rid = 11:20,
  aircraft = rep("Airplane", 10),
  airport = c("ONTARIO INTL ARPT", "CHICAGO O'HARE INTL ARPT", "GROTON-NEW LONDON AR", "SPIRIT OF ST LOUIS", "THEODORE FRANCIS GREEN STATE", "KANSAS CITY INTL", "LIHUE ARPT", "PHOENIX SKY HARBOR", "Ganavaram ARPT", "Kempagowda INTL"),
  model = c("PA-28", "C-208", "BE-90  KING", "A-320", "C-402", "C-402", "B-52H", "B-767-400", "B-717-200", "SAAB-340"),
  impact = c("Engine Shut Down", "None", "None", "Precautionary Landing", "None", "None","None", "Engine Shut Down", "None", "None"),
  flight_date = c("1/8/2000 0:00", "1/20/2000 0:00", "1/30/2000 0:00", "1/30/2000 0:00", "1/30/2000 0:00", "2/1/2000 0:00", "2/11/2000 0:00", "2/12/2000 0:00", "2/18/2000 0:00", "2/23/2000 0:00"),
  damage = c("No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "No damage"),
  airline = c("FLIGHT OPTIONS", "BUSINESS", "FLIGHT OPTIONS", "UNITED AIRLINES", "BUSINESS", "ATLANTIC SOUTHEAST", "BUSINESS", "US AIRWAYS", "AMERICAN AIRLINES", "US AIRWAYS"),
  origin = c("California", "Illinois", "Connecticut", "Missouri", "RhodeIsland", "Missouri", "Hawaii", "Arizona", "Vijayawada", "Bengaluru"),
  flight_phase = c("Approach", "Approach", "Landing Roll", "Approach", "Approach", "Approach", "Take-off run", "Landing Roll", "Climb", "Climb"),
  wildlife_size = c("Small", "Large", "Small", "Small", "Small", "Large", "Small", "Small", "Small", "Small"),
  sky_conditions = c("Some Cloud", "No Cloud", "Overcast", "Overcast", "No Cloud", "Some Cloud", "No Cloud", "Overcast", "Some Cloud", "Some Cloud"),
  pilot_warned_flag = c("N", "N", "N", "N", "N", "Y", "Y", "N", "N", "N"),
  altitude_ft = c(200, 1700, 0, 1800, 50, 500, 0, 0, 800, 500),
  heavy_flag = c("No", "No", "No", "No", "Yes", "No", "No", "Yes", "Yes", "No")
)
write.csv(bird_strikes_2, "bird_strikes_2.csv", row.names = FALSE)

bird_strikes_3 <- data.frame(
  rid = 21:30,
  aircraft = rep("Airplane", 10),
  airport = c("Beijing Capital", "Indira Gandhi INTL", "Los Angeles International", "Newark Liberty", "Amsterdam Schiphol", "Tallahassee Airport", "Madrid Barajas", "Rome Fiumicino", "Chicago O'Hare", "Dallas/Fort Worth"),
  model = c("A330", "B777", "A350", "B737", "A320", "B787", "A380", "B737-800", "A320", "B747"),
  impact = c("None", "Precautionary Landing", "None", "Engine Shut Down", "None", "None", "Engine Shut Down", "None", "Precautionary Landing", "None"),
  flight_date = rep("2023-05-15 0:00", 10),
  damage = c("No damage", "Damage", "No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "Damage", "No damage"),
  airline = c("Air China", "Kingfisher Airlines", "American Airlines", "United Airlines", "KLM", "Air France", "Iberia", "Alitalia", "American Airlines", "Delta Airlines"),
  origin = c("Beijing", "Bengaluru", "California", "New Jersey", "Netherlands", "France", "Spain", "Italy", "Illinois", "Texas"),
  flight_phase = c("Climb", "Approach", "Climb", "Approach", "Climb", "Approach", "Climb", "Approach", "Climb", "Approach"),
  wildlife_size = c("Medium", "Large", "Small", "Medium", "Large", "Small", "Medium", "Large", "Small", "Medium"),
  sky_conditions = c("Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast"),
  pilot_warned_flag = c("N", "Y", "N", "Y", "N", "Y", "N", "Y", "N", "Y"),
  altitude_ft = c(300, 2000, 1500, 500, 300, 1500, 2000, 100, 500, 200),
  heavy_flag = c("No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes")
)
write.csv(bird_strikes_3, "bird_strikes_3.csv", row.names = FALSE)

bird_strikes_4 <- data.frame(
  rid = 31:40,
  aircraft = rep("Airplane", 10),
  airport = c("Ted Stevens INTL", "London Gatwick", "Munich Airport", "Zurich Airport", "Vienna International", "Brussels Airport", "JFK INTL", "Oslo Airport", "Helsinki-Vantaa", "Copenhagen Airport"),
  model = c("B737", "A320", "B747", "A380", "B787", "A350", "A330", "B777", "A320", "B737-800"),
  impact = c("Engine Shut Down", "None", "Precautionary Landing", "None", "Engine Shut Down", "None", "None", "Precautionary Landing", "None", "None"),
  flight_date = rep("2023-06-15 0:00", 10),
  damage = c("Damage", "No damage", "Damage", "No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "No damage"),
  airline = c("Delta Airlines", "British Airways", "Lufthansa", "Swiss International Air Lines", "Austrian Airlines", "Brussels Airlines", "Etihad Airlines", "Norwegian Air Shuttle", "Finnair", "Danish Air Transport"),
  origin = c("Georgia", "United Kingdom", "Germany", "Switzerland", "Austria", "Belgium", "Sweden", "Norway", "Finland", "Denmark"),
  flight_phase = c("Approach", "Climb", "Approach", "Climb", "Approach", "Approach", "Climb", "Climb", "Approach", "Climb"),
  wildlife_size = c("Small", "Medium", "Small", "Medium", "Large", "Small", "Medium", "Large", "Small", "Medium"),
  sky_conditions = c("No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud"),
  pilot_warned_flag = c("N", "Y", "N", "N", "Y", "N", "N", "Y", "N", "N"),
  altitude_ft = c(2000, 100, 500, 2000, 300, 1500, 1000, 200, 700, 400),
  heavy_flag = c("Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No")
)
write.csv(bird_strikes_4, "bird_strikes_4.csv", row.names = FALSE)


bird_strikes_5 <- data.frame(
  rid = 41:50,
  aircraft = rep("Airplane", 10),
  airport = c("Kuala Lumpur International", "Bangkok Suvarnabhumi", "Sultan Hasanuddin INTL", "Manila Ninoy Aquino", "Seoul Incheon", "Taipei Taoyuan", "Dublin Airport", "Zayed INTL", "Lisbon Airport", "Barcelona El Prat"),
  model = c("A350", "B787", "A330", "B777", "A320", "B737", "A380", "B747", "A320", "B737-800"),
  impact = c("None", "Engine Shut Down", "None", "Precautionary Landing", "None", "None", "Engine Shut Down", "None", "Precautionary Landing", "None"),
  flight_date = rep("2023-07-15 0:00", 10),
  damage = c("No damage", "Damage", "No damage", "Damage", "No damage", "No damage", "Damage", "No damage", "Damage", "No damage"),
  airline = c("Malaysia Airlines", "Thai Airways", "Garuda Indonesia", "Philippine Airlines", "Korean Air", "EVA Air", "Aer Lingus", "Etihad", "TAP Portugal", "Vueling"),
  origin = c("Malaysia", "Thailand", "Indonesia", "Philippines", "South Korea", "Taiwan", "Ireland", "Abu Dhabi", "Portugal", "Spain"),
  flight_phase = c("Climb", "Approach", "Climb", "Approach", "Climb", "Approach", "Climb", "Approach", "Climb", "Approach"),
  wildlife_size = c("Medium", "Large", "Small", "Medium", "Large", "Small", "Medium", "Large", "Small", "Medium"),
  sky_conditions = c("Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud", "Overcast", "No Cloud", "Some Cloud"),
  pilot_warned_flag = c("Y", "N", "Y", "N", "Y", "N", "Y", "N", "Y", "N"),
  altitude_ft = c(1500, 2000, 100, 500, 300, 1500, 2000, 100, 500, 200),
  heavy_flag = c("No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes", "No", "Yes")
)
write.csv(bird_strikes_5, "bird_strikes_5.csv", row.names = FALSE)

# Question 3:

load_new_rows <- function(bird_strikes_1, user = db_user, password = db_pwd,
                          dbname = db_name, host = db_host, port = db_port) {
  # Connect to the database
  dbConnect(RMariaDB::MariaDB(), user = db_user, password = db_pwd,
            dbname = db_name, host = db_host, port = db_port)
  
  # Start a transaction
  dbBegin(con)
  
  tryCatch({
    # Read the CSV file
    new_data <- read.csv(bird_strikes_1)
    dbWriteTable(con, "bird_strikes", new_data, append = TRUE, row.names = FALSE)
    
    # Commit the transaction
    dbCommit(con)
  }, error = function(e) {
    # Rollback if any error occurs
    dbRollback(con)
    stop("Error in transaction: ", e$message)
  })

}
# Question 4:

# Auxiliary function to remove test data 
remove_test_data <- function(ids_to_remove,  user = db_user, password = db_pwd,
                             dbname = db_name, host = db_host, port = db_port) {
  dbConnect(RMariaDB::MariaDB(), user = db_user, password = db_pwd,
            dbname = db_name, host = db_host, port = db_port)
  query <- sprintf("DELETE FROM bird_strikes WHERE id IN (%s)", paste(ids_to_remove, collapse = ", "))
  dbExecute(con, query)
}

# Example modification to accept a CSV file name as a command line argument
args <- commandArgs(trailingOnly = TRUE)
# Assuming the first argument is the CSV file name
csv <- args[1]
#changing existing csv file
data <- read.csv(csv)

# Question 5:

# Function to insert data with a delay
insert_data_with_delay <- function(data, connection, delay_seconds = 1) {
  for (row in 1:nrow(data)) {
    # Assuming 'bird_strikes' is your table, and it has columns corresponding to the CSV file
    dbWriteTable(con, "bird_strikes", data, append = TRUE, row.names = FALSE)
    
    
    # Add a delay after executing each insert
    Sys.sleep(delay_seconds)
  }
}

# Main script logic to read CSV file and insert data
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) == 0) {
    stop("No CSV file name provided. Please provide a file name as an argument.")
  }
  
  csv_file_name <- args[1]
  
  # Ensure the file exists
  if (!file.exists(csv_file_name)) {
    stop(paste("The file", csv_file_name, "does not exist."))
  }
  
  # Reading the CSV file
  bird_strikes_data <- read.csv(csv_file_name)
  
  # Insert data with a specified delay
  insert_data_with_delay(bird_strikes_data, con, 2)
}

# Question 7: 

# Call main function if this script is executed directly
if (!interactive()) {
  main()
}


insert_data <- function(data, connection, use_transactions) {
  if (use_transactions) {
    dbBegin(connection)
  }
  
  tryCatch({
    for (row in 1:nrow(data)) {
      sql <- "INSERT INTO bird_strikes (aircraft, airport, model, impact, flight_date, damage, airline, origin, flight_phase, wildlife_size, sky_conditions, pilot_warned_flag, altitude_ft, heavy_flag) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      dbExecute(connection, sql, params = list(data[row, "aircraft"], data[row, "airport"], data[row, "model"], data[row, "impact"], data[row, "flight_date"], data[row, "damage"], data[row, "airline"], data[row, "origin"], data[row, "flight_phase"], data[row, "wildlife_size"], data[row, "sky_conditions"], data[row, "pilot_warned_flag"], data[row, "altitude_ft"], data[row, "heavy_flag"]))
      
      # Add a delay after executing the SQL statement, for testing purposes
      Sys.sleep(1)
    }
    
    if (use_transactions) {
      dbCommit(connection)
    }
  }, error = function(e) {
    if (use_transactions) {
      dbRollback(connection)
    }
    stop("Error in transaction: ", e$message)
  })
  dbDisconnect()
}

