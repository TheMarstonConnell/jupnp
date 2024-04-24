#!/bin/bash

# Define the base directory relative to this script location
base_directory="docs"
output_directory="markdown_docs"

# Create the output directory if it does not exist
mkdir -p "$output_directory"

# Find all XHTML files and convert them
find "$base_directory" -type f -name "*.xhtml" | while read file; do
    # Create a corresponding directory structure in the output directory
    relative_path="${file#$base_directory/}" # Extract the relative path
    output_file_path="$output_directory/${relative_path%.xhtml}.md"
    mkdir -p "$(dirname "$output_file_path")" # Ensure the directory exists

    # Use Pandoc to convert the file to Markdown
    pandoc -f html -t markdown "$file" -o "$output_file_path"
    
    echo "Converted '$file' to '$output_file_path'"
done

echo "All files have been converted."
