#!/bin/bash

# Function to remove duplicates from PATH
remove_duplicates_from_path() {
    local old_path="$1"
    local new_path=""
    local IFS=':'
    local path_array=($old_path)

    declare -A seen

    for path in "${path_array[@]}"; do
        if [[ -n "$path" && -z "${seen[$path]}" ]]; then
            if [[ -n "$new_path" ]]; then
                new_path="$new_path:$path"
            else
                new_path="$path"
            fi
            seen[$path]=1
        fi
    done

    echo "$new_path"
}

# Get the current PATH
current_path="$PATH"

# Remove duplicates
cleaned_path=$(remove_duplicates_from_path "$current_path")

# Update the PATH
export PATH="$cleaned_path"

# Optionally, print the cleaned PATH to verify
echo "Cleaned PATH: $PATH"
