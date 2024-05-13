# Load necessary library
library(xml2)

# Define the XML structure
data <- '<to-do>
    <List name="Errands" category="personal">
        <Item iid="1" title="Grocery Shopping" desc="Buy milk, bread, and eggs" due="2024-04-05"/>
        <Item iid="2" title="Post Office" desc="Mail package to John" due="2024-04-06"/>
    </List>
    <List name="Homework" category="school">
        <Item iid="3" title="Math Assignment" desc="Complete algebra problems" due="2024-04-07"/>
        <Item iid="4" title="Science Project" desc="Prepare experiment materials" due="2024-04-10"/>
    </List>
    <List name="Home Improvement" category="home">
        <Item iid="5" title="Paint Bedroom" desc="Paint bedroom walls blue" due="2024-04-15"/>
        <Item iid="6" title="Fix Leaky Faucet" desc="Replace washer in bathroom sink" due="2024-04-20"/>
    </List>
</to-do>'

# Use the XML content to create an XML document object
doc <- read_xml(data)

# Specify the file path
path <- "KandruB.CS5200.List.xml"

# Write the XML content to a file
write_xml(doc, path)

# Print the file path for confirmation
cat("XML file written to:", path, "\n")