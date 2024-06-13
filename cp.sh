#!/bin/bash

# Script that constructs the classpath from cp.txt. This
# script is called by abTab every time it is run.

code_path=$1

# Read each line from cp.txt, prepend code_path, add
# semicolon, and append to classpath
# NB: for the last line to be read, cp.txt must end with
#     a line break
classpath=""
while IFS= read -r line; do
    classpath+="$code_path""$line;"
done < "$code_path""cp.txt"

# Remove any carriage returns; remove trailing semicolon
classpath=$(echo "$classpath" | tr -d '\r')
classpath=${classpath%;}

# Return the constructed classpath
echo "$classpath"