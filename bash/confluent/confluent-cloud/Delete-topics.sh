#!/bin/bash

# Check if a filename is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Check if the provided file exists
if [ ! -f "$1" ]; then
    echo "File $1 not found!"
    exit 1
fi

# Read each line from the file and run the command with each line as an argument
while IFS= read -r line; do
    echo "Running command with argument: $line"
    confluent kafka topic delete $line --environment=$env  --cluster=$cluster --force
done < "$1"
