#title: "ASSIGNMENT 06.1: Build Triggers in SQLite"
#name: "Bhavitha Naga Sai Kandru"
#date: "02/18/2024"

# Loading packages.
library(sqldf)
library(knitr)
library(dplyr)
library(RSQLite)
# loading database
dbcon <- dbConnect(RSQLite::SQLite(),dbname = "MediaDB.db")

# 1) Using R code, add a new column in the table "albums" called "play_time" 
#(if it does not yet exist) as a numeric type that allows fractional positive values, e.g., 12.30 or 165.87.

if (!("play_time" %in% dbListFields(dbcon,'albums'))) {
  # Since 'play_time' is not found, we add it to the 'albums' table
  dbExecute(dbcon, "ALTER TABLE albums ADD COLUMN play_time NUMERIC")
} else {
  # 'play_time' already exists, so we do not need to add it
  print("'play_time' column already exists in the 'albums' table.")
}

# 2) Update the table modification from the prior question, so that there is a 
#constraint as part of the table modification so that only positive values are 
#allowed to be inserted into the table. If that is not possible due to database 
#restrictions, create a new table, set the constraint as part of the new table 
#definition, and copy the data from the old table.

# Create a new table with the constraint
dbExecute(dbcon, "
  CREATE TABLE IF NOT EXISTS new_albums (
    AlbumId INTEGER PRIMARY KEY,
    Title NVARCHAR(160),
    ArtistId INTEGER,
    play_time NUMERIC CHECK(play_time > 0)
  )
")
# Clear the 'new_albums' table before inserting new data
dbExecute(dbcon, "DELETE FROM new_albums")
# Copy the data from the old 'albums' table to the new 'albums' table
dbExecute(dbcon, "
  INSERT INTO new_albums (AlbumId, Title, ArtistId)
  SELECT AlbumId, Title, ArtistId FROM albums
")
# Clear the 'old_albums' table before inserting new data
dbExecute(dbcon, "DELETE FROM old_albums")
# Rename the old table and change the new one to 'albums'
dbExecute(dbcon, "ALTER TABLE albums RENAME TO old_albums")
dbExecute(dbcon, "ALTER TABLE new_albums RENAME TO albums")

#3) Create an update statement that updates the new "play_time' column to 
#contain the total play time (in minutes) for an album based on the tracks it contains.

dbExecute(dbcon, "
UPDATE albums SET play_time = (
  SELECT SUM(Milliseconds) / 60000.0
  FROM tracks
  WHERE tracks.AlbumId = albums.AlbumId
)
")

# 4) Attach an "after insert" trigger on the tables "tracks" that recalculates 
#the "play_time" value to ensure that it is always correct. So, for example, if
#a new track is added to an album, then the "play_time" column is updated.

# Add an "after insert" trigger to the 'tracks' table
dbExecute(dbcon, "
  CREATE TRIGGER IF NOT EXISTS after_track_insert
  AFTER INSERT ON tracks
  FOR EACH ROW
  BEGIN
    UPDATE albums SET play_time = (
      SELECT SUM(Milliseconds) / 60000.0
      FROM tracks
      WHERE tracks.AlbumId = NEW.AlbumId
    ) WHERE AlbumId = NEW.AlbumId;
  END;
")


# 5) Ensure that the same recalculation occurs after an "update" and after a 
#"delete", i.e., if track is removed or updated.

dbExecute(dbcon, "
  CREATE TRIGGER IF NOT EXISTS after_track_update
  AFTER UPDATE ON tracks
  FOR EACH ROW
  BEGIN
    UPDATE albums SET play_time = (
      SELECT SUM(Milliseconds) / 60000.0
      FROM tracks
      WHERE tracks.AlbumId = NEW.AlbumId
    ) WHERE AlbumId = NEW.AlbumId;
  END;
")

# Add "after delete" trigger
dbExecute(dbcon, "
  CREATE TRIGGER IF NOT EXISTS after_track_delete
  AFTER DELETE ON tracks
  FOR EACH ROW
  BEGIN
    UPDATE albums SET play_time = (
      SELECT SUM(Milliseconds) / 60000.0
      FROM tracks
      WHERE tracks.AlbumId = OLD.AlbumId
    ) WHERE AlbumId = OLD.AlbumId;
  END;
")

# 6) Demonstrate that your trigger(s) work properly.

# Demonstration of insert
dbExecute(dbcon, "INSERT INTO tracks (Name, AlbumId, MediaTypeId, GenreId, 
          Composer, Milliseconds, Bytes, UnitPrice) VALUES ('New Track', 1, 1, 1, 
          'Composer', 240000, 0, 0.99)")
# Check the updated play_time
dbGetQuery(dbcon, "SELECT play_time FROM albums WHERE AlbumId = 1")

# Demonstration of update
dbExecute(dbcon, "UPDATE tracks SET Milliseconds = 300000 WHERE TrackId = (SELECT MAX(TrackId) FROM tracks)")
# Check the updated play_time
dbGetQuery(dbcon, "SELECT play_time FROM albums WHERE AlbumId = 1")

# Demonstration of delete
dbExecute(dbcon, "DELETE FROM tracks WHERE TrackId = (SELECT MAX(TrackId) FROM tracks)")

# Close the database connection
dbDisconnect(db)
