#!/bin/bash

# Setup the package directory and clean previous installations
package_dir="./package"
mkdir -p $package_dir
rm -rf $package_dir/*  # Clear any existing files

# Navigate to the package directory
cd $package_dir

# Install dependencies quietly, suppress warnings
pip install --target . boto3 > /dev/null 2>&1

# Navigate back to the function directory
cd ..

# Get the name of the current directory to use as the ZIP filename
zip_file_name=$(basename "$PWD")".zip"

# Add all required files to the zip file, excluding the package directory itself
zip -r $zip_file_name . -x "package/*" > /dev/null

# Create hash for zip
zip_hash=$(md5sum "$zip_file_name" | cut -d ' ' -f 1)

# Print the path and hash of the zip file in JSON format
echo "{\"zip_path\":\"$PWD/$zip_file_name\", \"zip_hash\":\"$zip_hash\"}"

# Ensure that the cleanup does not print any output
function cleanup {
    rm -rf $package_dir > /dev/null 2>&1
}

# Trap to execute cleanup on script exit, error or interruption
trap cleanup EXIT ERR INT

exit 0
