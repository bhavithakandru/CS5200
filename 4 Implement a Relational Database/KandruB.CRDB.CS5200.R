library(DBI)
library(RSQLite)

# Create a new SQLite database file
db_file <- "lessonDB-KandruB.sqlitedb"
conn <- dbConnect(RSQLite::SQLite(), dbname = db_file)

# Enable foreign Keys
dbExecute(conn, "PRAGMA foreign_keys = ON")

# Drop existing tables if they exist
tables <- c("LessonPrerequisites", "Lesson", "Module")
for (table in tables) {
  query <- sprintf("DROP TABLE IF EXISTS %s;", table)
  dbExecute(conn, query)
}

# Create the Lesson table
dbExecute(conn, "
  CREATE TABLE Lesson (
    category INTEGER NOT NULL,
    number INTEGER NOT NULL,
    title TEXT NOT NULL,
    PRIMARY KEY (category, number)
  );
")

# Create the Module table
dbExecute(conn, "
  CREATE TABLE Module (
    mid TEXT NOT NULL,
    title TEXT NOT NULL,
    lengthInMinutes INTEGER NOT NULL,
    difficulty TEXT NOT NULL CHECK(difficulty IN ('beginner', 'intermediate', 'advanced')),
    PRIMARY KEY (mid)
  );
")

# Create a junction table for Lesson prerequisites (many-to-many relationship)
dbExecute(conn, "
  CREATE TABLE LessonPrerequisites (
    category INTEGER NOT NULL,
    number INTEGER NOT NULL,
    prerequisite_category INTEGER NOT NULL,
    prerequisite_number INTEGER NOT NULL,
    FOREIGN KEY (category, number) REFERENCES Lesson(category, number),
    FOREIGN KEY (prerequisite_category, prerequisite_number) REFERENCES Lesson(category, number),
    PRIMARY KEY (category, number, prerequisite_category, prerequisite_number)
  );
")

# Insert test data into the Module table
dbExecute(conn, "INSERT INTO Module (mid, title, lengthInMinutes, difficulty) VALUES ('M001', 'Introduction to SQL', 30, 'beginner')")
dbExecute(conn, "INSERT INTO Module (mid, title, lengthInMinutes, difficulty) VALUES ('M002', 'Advanced SQL Queries', 45, 'intermediate')")
dbExecute(conn, "INSERT INTO Module (mid, title, lengthInMinutes, difficulty) VALUES ('M003', 'SQL for Data Science', 50, 'advanced')")

# Insert test data into the Lesson table
dbExecute(conn, "INSERT INTO Lesson (category, number, title) VALUES (1, 101, 'Database systems')")
dbExecute(conn, "INSERT INTO Lesson (category, number, title) VALUES (1, 102, 'Data modeling')")
dbExecute(conn, "INSERT INTO Lesson (category, number, title) VALUES (2, 201, 'Normalization')")
dbExecute(conn, "INSERT INTO Lesson (category, number, title) VALUES (2, 202, 'Database schema')")

# Insert test data into the LessonPrerequisites table
dbExecute(conn, "INSERT INTO LessonPrerequisites (category, number, prerequisite_category, prerequisite_number) VALUES (2, 201, 1, 101)")
dbExecute(conn, "INSERT INTO LessonPrerequisites (category, number, prerequisite_category, prerequisite_number) VALUES (2, 202, 1, 102)")

# Close the connection
dbDisconnect(conn)
