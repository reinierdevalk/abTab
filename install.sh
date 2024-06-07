#!/bin/bash

# Script that installs `abTab`. It must be called from the
# same folder that folds config.cfg, cp.sh, and cp.txt.

remove_carriage_returns() {
    local file="$1"
    if grep -q $'\r' "$file"; then
        tr -d '\r' <"$file" >file.new && mv file.new "$file"
    fi
}

handle_file() {
    local file="$1"
    local make_executable="$2"
    # If the file exists, handle it
    if [ -f "$file" ]; then
        # Remove any carriage returns
        # All line endings in a script called by bash must be Unix style ('\n') 
        # and not Windows style ('\r\n'), which cause the following error:
        # 
        #   ./<my_script>.sh: line <n>: $'\r': command not found
        #    
        # Any carriage returns ('\r') must therefore be removed.
        #
        # NB: Carriage returns can be avoided by creating the file in Sublime 4,
        # after adding the following in the right field at Preferences > Settings:
        #
        #   {
        #    "default_line_ending": "unix"
        #   }
        remove_carriage_returns "$file"

        # Make executable (if applicable)
        if [ "$make_executable" -eq 1 ]; then
            chmod +x "$file"
        fi
    # If not, return error
    else
        echo "File not found: $file."
        exit 1
    fi
}

echo "Installing ..."

# 1. Handle files
config_file="$(pwd)""/config.cfg"
handle_file "$config_file" 0
cp_file="cp.sh"
handle_file "$cp_file" 1
#tm_file="tabmapper"
#handle_file "$tm_file" 1
at_file="abTab"
handle_file "$at_file" 1

# 2. Source config.cfg to make ROOT_PATH, CODE_PATH, and PATH_PATH 
#    available locally
echo "... reading configuration file ... "
source "$config_file"
full_path="$ROOT_PATH""$CODE_PATH"
# Escape forward slashes in full_path
full_path_esc=$(echo "$full_path" | sed 's/\//\\\//g')

# 3. Set full code path in files (replace placeholder with escaped full code path)
echo "... setting path to code ... "
placeholder="cp_placeholder"
sed -i "s/$placeholder/$full_path_esc/g" "$cp_file"
sed -i "s/$placeholder/$full_path_esc/g" "$at_file"        

## 4. Create folders
#echo "... creating folders ... "
#tabmapper_path="$full_path""tabmapper/"
#data_in="$tabmapper_path""data/in/"
#data_in_tab="$tabmapper_path""data/in/tab/"
#data_in_MIDI="$tabmapper_path""data/in/MIDI/"
#data_out="$tabmapper_path""data/out/"
#if [ ! -d "$data_in" ]; then
#    mkdir -p "$data_in"
#fi
#if [ ! -d "$data_in_tab" ]; then
#    mkdir -p "$data_in_tab"
#fi
#if [ ! -d "$data_in_MIDI" ]; then
#    mkdir -p "$data_in_MIDI"
#fi
#if [ ! -d "$data_out" ]; then
#    mkdir -p "$data_out"
#fi

# 5. Copy abTab to global environment
echo "... copying abTab to "$PATH_PATH" ..."
cp "$at_file" "$PATH_PATH"

echo "done!"