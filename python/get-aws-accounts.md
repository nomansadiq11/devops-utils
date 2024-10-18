# Get list of AWS accounts in txt from from AWS SSO page

## Usecase

- I need to collect all the aws accounts from SSO page, so I write a python script todo this job

> download the souce code in html format file and pass that file name in the code and run

```python
from bs4 import BeautifulSoup

# Read the HTML content from the file
with open('getaccountpage.html', 'r') as file:
    html_content = file.read()

# Create BeautifulSoup object
soup = BeautifulSoup(html_content, 'html.parser')

# Find all div elements with class "instance-block"
div_elements = soup.find_all('div', class_='instance-block')

# Read the existing data file
with open('existing_data.txt', 'r') as existing_file:
    existing_data = existing_file.read()

# Create a string to store the formatted data
filtered_data = ""
all_data = ""

# Initialize sequence number
seq_no = 1

# Iterate through each div element and extract the required values
for div in div_elements:
    name = div.find('div', class_='name').text
    account_id = div.find('span', class_='accountId').text

    # Check if the status is not "DONE"
    if f"{name} | {account_id} | DONE" not in existing_data:
        filtered_data += f"{seq_no} | {name} | {account_id} |\n"

    all_data += f"{seq_no} | {name} | {account_id} |\n"
    seq_no += 1

# Save the filtered data to a new file
with open('new_filtered_data.txt', 'w') as output_file:
    output_file.write(filtered_data)

# Save all the data to another file
with open('all_data.txt', 'w') as all_data_file:
    all_data_file.write(all_data)

print("Filtered data saved to new_filtered_data.txt")
print("All data saved to all_data.txt")


```
