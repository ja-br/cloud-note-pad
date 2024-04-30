#!/bin/bash

# Setup the package directory and clean previous installations
package_dir="./package"
mkdir -p $package_dir
rm -rf $package_dir/*  # Clear any existing files to avoid the 'already exists' warning

# Navigate to the package directory
cd $package_dir

# Install dependencies quietly, suppress warnings
pip install --target . boto3 > /dev/null 2>&1

# Navigate back to the function directory
cd ..

# Add all required files to the zip file, excluding the package directory itself
zip -r create_note.zip . -x "package/*" > /dev/null

# Print path to zip file to stdout if needed or handle internally
echo "$PWD/create_note.zip"
