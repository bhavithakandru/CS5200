library(xml2)

## Question 1: Create an appropriate internal DTD. Be sure to view the XML to 
#ensure it validates by either loading in into R with validation or using an ad 
#hoc validation tool such as xmlvalidation.com Links to an external site.. 

# Define the XML structure with an internal DTD
xml_data <- '<?xml version="1.0"?>
<!DOCTYPE to-do [
<!ELEMENT to-do (List*)>
<!ELEMENT List (Item*)>
<!ATTLIST List
    name CDATA #REQUIRED
    category (personal|school|home) #REQUIRED>
<!ELEMENT Item EMPTY>
<!ATTLIST Item
    iid CDATA #REQUIRED
    title CDATA #REQUIRED
    desc CDATA #REQUIRED
    due CDATA #REQUIRED>
]>
<to-do>
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

# Create the XML document object with internal DTD
doc <- read_xml(xml_data)

# Validate the XML. This will only check if the XML is well-formed, not if it is valid against the DTD, 
# because the xml2 package does not support DTD validation.
# For actual DTD validation, other tools or software would be needed outside of R.

# Write the XML content to a file
file <- "KandruB.CS5200.List.withDTD.xml"
write_xml(doc, file)

# Output the path to the created file
cat("XML file with DTD created at:", file, "\n")

file <- "KandruB.CS5200.List.withDTD.xml"

# Use xmlParse() to read and validate the XML file

xml_data <- xmlParse(file, validate = TRUE)

# Print a success message if no error is thrown
print("XML file has been successfully read and validated.")

## Question 2: Create a R program in your project with the naming pattern 
#LastNameF.CS5200.Sp24.ListsXML.R. Read the XML into R using xmlParse() (with validation).

code <- c(
  "# Ensure the XML package is installed and loaded",
  "if (!require(\"XML\")) install.packages(\"XML\")",
  "library(XML)",
  "",
  "# Define the file path to the XML file with DTD",
  "file_path <- \"<Your Path Here>/KandruB.CS5200.List.withDTD.xml\"",
  "",
  "# Use xmlParse() to read and validate the XML file",
  "xml_data <- xmlParse(file_path, validate = TRUE)",
  "",
  "# Print a success message if no error is thrown",
  "print(\"XML file has been successfully read and validated.\")"
)

# Define the file name according to your naming pattern
file_name <- "KandruB.CS5200.Sp24.ListsXML.R"

# Write the R code to the file
writeLines(code, file_name)

# Output to indicate success
cat("R program written to:", file_name, "\n")


## Question 3: Use XPath to find the total number of items in some list 
#(pick one from your sample instances). Display the result to show that your XML 
#was correctly encoded, validates, and can be processed. Hint: you cannot use 
#xmlToDataFrame() to read the XML back into a single data frame.
file_path <- "KandruB.CS5200.List.withDTD.xml"

# Parse the XML file
xml_doc <- xmlParse(file_path)

# Use XPath to find the total number of items in the "Errands" list
errands <- getNodeSet(xml_doc, "//List[@name='Errands']/Item")

# Display the total number of items in the "Errands" list
total_items <- length(errands)
cat("Total number of items in the 'Errands' list:", total_items, "\n")
