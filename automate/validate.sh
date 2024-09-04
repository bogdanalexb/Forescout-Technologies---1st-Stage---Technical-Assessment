#!/bin/bash

user_id=$1

# Path to the CSV file
csv_file="data.csv"

# External API URL
api_url="https://jsonplaceholder.typicode.com/users/${user_id}"

# Function to get data from the CSV
get_csv_data() {
  grep "^${user_id}," "$csv_file" | while IFS=',' read -r id name email phone website
  do
    echo "$name,$email,$phone,$website"
  done
}

# Function to get data from the API using curl
get_api_data() {
  curl -s "$api_url" | jq -r '[.name, .email, .phone, .website] | @csv'
}

expected_data=$(get_csv_data)

if [[ -z "$expected_data" ]]; then
  echo "User ID ${user_id} not found in the CSV file."
  exit 1
fi

actual_data=$(get_api_data)

# Validate if the API data matches the CSV data
if [[ "$expected_data" == "$actual_data" ]]; then
  echo "Test Passed: Data for user_id ${user_id} matches!"
else
  echo "Test Failed: Data for user_id ${user_id} does not match."
  echo "Expected: $expected_data"
  echo "Actual: $actual_data"
fi