#!/usr/bin/Python
# title: ASSIGNMENT 06.3: Build Triggers in SQLite with Python
# name: Bhavitha Naga Sai Kandru
# date: Spring2024

import sqlite3

# Connect to the SQLite database
conn = sqlite3.connect('MediaDB.db')
cur = conn.cursor()

# 1) Adding a new column if it doesn't exist
cur.execute("PRAGMA table_info(albums)")
columns = [info[1] for info in cur.fetchall()]
if 'play_time' not in columns:
    cur.execute("ALTER TABLE albums ADD COLUMN play_time NUMERIC")
else:
    print("'play_time' column already exists in the 'albums' table.")

# 2) Since SQLite does not support adding constraints to existing columns,
# we create a new table with the constraint, copy data, and rename tables.
cur.execute("""
CREATE TABLE IF NOT EXISTS albums_new (
    AlbumId INTEGER PRIMARY KEY,
    Title TEXT NOT NULL,
    ArtistId INTEGER NOT NULL,
    play_time NUMERIC CHECK(play_time > 0)
)
""")

# Copy existing data without play_time as it can't have the constraint directly applied
cur.execute("INSERT INTO albums_new (AlbumId, Title, ArtistId) SELECT AlbumId, Title, ArtistId FROM albums")

# Drop the old 'albums' table and rename 'albums_new' to 'albums'
cur.execute("DROP TABLE albums")
cur.execute("ALTER TABLE albums_new RENAME TO albums")

# 3) Update the 'play_time' column with the total play time
cur.execute("""
UPDATE albums SET play_time = (
    SELECT SUM(Milliseconds) / 60000.0 FROM tracks WHERE tracks.AlbumId = albums.AlbumId
)
""")
conn.commit()

# 4), 5) Creating triggers for insert, update, and delete actions on 'tracks' table
triggers = [
    """
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
    """,
    """
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
    """,
    """
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
    """
]

for trigger in triggers:
    cur.execute(trigger)
conn.commit()

# 6) Demonstrate that your trigger(s) work properly.
# Example insert
cur.execute("""
    INSERT INTO tracks (Name, AlbumId, MediaTypeId, GenreId, Composer, Milliseconds, Bytes, UnitPrice)
    VALUES ('New Track', 1, 1, 1, 'Composer', 240000, 0, 0.99)
""")
conn.commit()

# Check the updated play_time
cur.execute("SELECT play_time FROM albums WHERE AlbumId = 1")
print("After insert:", cur.fetchone()[0])

# Example update
cur.execute("""
    UPDATE tracks SET Milliseconds = 300000 WHERE TrackId = (
        SELECT MAX(TrackId) FROM tracks
    )
""")
conn.commit()

# Check the updated play_time
cur.execute("SELECT play_time FROM albums WHERE AlbumId = 1")
print("After update:", cur.fetchone()[0])

# Example delete
cur.execute("""
    DELETE FROM tracks WHERE TrackId = (
        SELECT MAX(TrackId) FROM tracks
    )
""")
conn.commit()

# Check the updated play_time
cur.execute("SELECT play_time FROM albums WHERE AlbumId = 1")
print("After delete:", cur.fetchone()[0])

# Close the connectio
# Finally, close the database connection
conn.close()