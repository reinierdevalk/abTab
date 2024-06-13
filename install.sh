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

# 1. Handle files TODO what about cp.txt, paths.json, and this file (install.sh)?
config_file="config.cfg"
#config_file="$(pwd)""/config.cfg"
handle_file "$config_file" 0
cp_file="cp.sh"
handle_file "$cp_file" 1
abtab_file="abTab"
handle_file "$abtab_file" 1

# 2. Source config.cfg to make *_PATHs available locally
echo "... reading configuration file ... "
source "$config_file"
root_path="$ROOT_PATH"
code_path="$LIB_PATH"
#code_path_parent=$(dirname "$code_path")"/" # code path without abTab/ dir
exe_path="$EXE_PATH"
# Set code_path in executable
placeholder="cp_placeholder"
# Escape forward slashes and replace placeholder with result
code_path_esc=$(echo "$code_path" | sed 's/\//\\\//g')
sed -i "s/$placeholder/$code_path_esc/g" "$abtab_file"

# 3. Handle config paths
echo "... handling paths ... "
config_paths=(
              "$root_path"
              "$(dirname "$code_path")""/" # code path without abTab/ dir
              "$exe_path"
             )
for path in "${config_paths[@]}"; do
    if [ ! -d "$path" ]; then
        mkdir -p "$path"
    fi
done

# 4. Clear code_path and exe_path
# a. code_path (/usr/local/lib/abTab/)
echo "    ... clearing $code_path ..."
if [ -d "$code_path" ]; then
    rm -r "$code_path" # remove the last dir (abTab/) on code_path 
fi
mkdir -p $code_path
# b. exe_path (/usr/local/bin/)
echo "    ... clearing $exe_path ..." 
if [ -f "$exe_path""$abtab_file" ]; then
    rm -f "$exe_path""$abtab_file" 
fi

## 5. Clone repos into pwd
## Extract parts before first slash; sort; get unique values
#repos=$(cut -d '/' -f 1 "cp.txt" | sort | uniq)
#for repo in $repos; do
#    # Ignore elements starting with a dot
#    if [[ ! "$repo" =~ ^\. ]]; then
#        repo_url="https://github.com/reinierdevalk/$repo.git"
#        echo "... cloning $repo_url ..."
#        git clone "$repo_url"
#    fi
#done

# 6. Make dirs on root_path
echo "... creating directories on $root_path ..."
paths=(
       "templates/" 
       "tabmapper/in/tab/" "tabmapper/in/MIDI/" "tabmapper/out/"
       "transcriber/in/" "transcriber/out/"
       "polyphonist/models" "polyphonist/in/" "polyphonist/out/"
       )
for path in "${paths[@]}"; do
    if [ ! -d "$root_path""$path" ]; then
        mkdir -p "$root_path""$path"
    fi
done

# 7. Install abTab
echo "... installing abTab ..."
# Copy executable to exe_path
cp "$abtab_file" "$exe_path"
# Copy contents of pwd (excluding executable) to code_path
for item in *; do
    if [ "$item" != "$abtab_file" ]; then
        cp -r "$item" "$code_path"
    fi
done
#rsync -av --exclude="$abtab_file" ./ "$code_path"

echo "done!"



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