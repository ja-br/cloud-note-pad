#!/bin/bash

lambda_root_dir="./lambda"
declare -A zip_paths

# Navigate through each lambda function directory
for dir in $lambda_root_dir/*; do
    if [ -d "$dir" ]; then
        function_name=$(basename "$dir")
        echo "Packaging Lambda function: $function_name" >&2
        cd "$dir"
        chmod +x package.sh
        
        # Run package script and capture the output
        zip_path=$(./package.sh)
        
        # Verify the zip was created
        if [ -f "$zip_path" ]; then
            zip_paths[$function_name]=$zip_path
        else
            echo "Failed to package or find ZIP file for $function_name" >&2
            exit 1
        fi
        cd - > /dev/null
    fi
done

# Generate JSON output
echo "{"
first=true
for key in "${!zip_paths[@]}"; do
    if [ "$first" = true ]; then
        first=false
    else
        echo -n ","
    fi
    echo -n "\"${key}_zip_path\": \"${zip_paths[$key]}\""
done
echo "}"
