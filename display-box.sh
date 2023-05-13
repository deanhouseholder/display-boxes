#!/bin/bash
#
# This script allows you to pipe in a multi-line input string
# and it will parse out the top line as a header and call the
# display-box function on the output.
#
# You can still use the flags to modify settings such as:
# echo "$multi_line_string" | /path/to/display-box.sh -s 2 -p 2 -d ,
#

if [[ -f "${0%/*}/display-boxes.sh" ]]; then
  source "${0%/*}/display-boxes.sh"
else
  printf "Error: Could not find display-boxes.sh in the same directory as this script.\n"
  exit 1
fi

# Capture stdin and separate header from body
input="$(cat)"
headers="${input%%$'\n'*}"
body="${input#*$'\n'}"

# Process flag options. Ignore anything else
while [[ $# != 0 ]]; do
  case "$1" in
    -s) [[ ! -z "$2" ]] && { style="-s $2"; shift 2; } || shift;;
    -p) [[ ! -z "$2" ]] && { padding="-p $2"; shift 2; } || shift;;
    -d) [[ ! -z "$2" ]] && { delimiter="-d $2"; shift 2; } || shift;;
    *) shift;;
  esac
done

display-box "$headers" "$body" $style $padding $delimiter
