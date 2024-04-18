#!/bin/bash

# Setup the package directory and clean previous installations
package_dir="./package"
mkdir -p $package_dir
rm -rf $package_dir/*  # Clear any existing files to avoid clutter

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

# Print the full path to the zip file to stdout for capturing in scripts
echo "$PWD/$zip_file_name"
