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

# 2. Source config.cfg and make *_PATHs available locally
echo "... reading configuration file ... "
source "$config_file"
root_path="$ROOT_PATH"
code_path="$LIB_PATH"
exe_path="$EXE_PATH"

# 3. Set path to code in executable
echo "... setting path to code in abTab ... "
placeholder="cp_placeholder"
# Escape forward slashes and replace placeholder with result
code_path_esc=$(echo "$code_path" | sed 's/\//\\\//g')
sed -i "s/$placeholder/$code_path_esc/g" "$abtab_file"

# 4. Check code_path and exe_path
Handle code dir and executable 
# a. Code dir
code_path_first=$(dirname "$code_path")"/" # code path up to abTab/ dir
code_path_last=$(basename "$code_path")"/" # abTab/ dir
# If code path exists: empty it (if necessary)
if [ -d "$code_path" ]; then
  if [ "$(ls -A "$code_path")" ]; then
    rm -rf "${code_path:?}/"*
    echo "    ... emptying existing dir $code_path_last on $code_path_first ..."
  else
    echo "    ... empty dir $code_path_last on $code_path_first already exists ..."
  fi
# If code path does not exist: create it
else
  mkdir -p "$code_path"
  echo "    ... creating dir $code_path_last on $code_path_first ..."
fi
# b. Executable
# If executable exists: delete it
if [ -f "$exe_path""$abtab_file" ]; then
  rm "$exe_path""$abtab_file"
  echo "    ... deleting existing executable $abtab_file on $exe_path ..."
fi

# 5. Clone repos into dir holding this script
# Extract parts before first slash; sort; get unique values
repos=$(cut -d '/' -f 1 "cp.txt" | sort | uniq)
for repo in $repos; do
    # Ignore elements starting with a dot
    if [[ ! "$repo" =~ ^\. ]]; then
        repo_url="https://github.com/reinierdevalk/$repo.git"
        echo "... cloning $repo_url ..."
        git clone "$repo_url"
    fi
done



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

## 5. Copy abTab to global environment
#echo "... copying abTab to "$PATH_PATH" ..."
#cp "$abtab_file" "$PATH_PATH"

echo "done!"