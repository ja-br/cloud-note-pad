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

        # Capture output and ensure it's treated as JSON
        zip_output=$(./package.sh 2>/dev/null)  # Redirect all stderr to null to isolate JSON
        echo "Debug: Package.sh output: $zip_output" >&2

        # Validate and parse JSON output
        if echo "$zip_output" | jq empty 2>/dev/null; then
            zip_path=$(echo "$zip_output" | jq -r '.zip_path')
            zip_hash=$(echo "$zip_output" | jq -r '.zip_hash')

            if [ -f "$zip_path" ]; then
                zip_paths[$function_name]=$zip_path
                echo "Successfully packaged $function_name" >&2
            else
                echo "Failed to package or find ZIP file for $function_name" >&2
                exit 1
            fi
        else
            echo "Failed to parse JSON output for $function_name: $zip_output" >&2
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
