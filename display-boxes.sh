#!/bin/bash

display-box() {
  # Catch missing inputs
  local error=0
  if [[ -z "$1" ]]; then
    echo "Missing required \$headers argument"
    error=1
  fi
  if [[ -z "$2" ]]; then
    echo "Missing required \$body argument"
    error=1
  fi
  if [[ ! -z "$3" ]] && [[ ! "$3" =~ ^[1-6]$ ]]; then # Make sure it's a positive integer with a valid style number
    echo "Invalid style number. Valid options: 1-6"
    error=1
  fi
  if [[ "$error" -eq 1 ]]; then
    return
  fi

  # Set the amount of padding between column bars and data
  if [[ -z "$4" ]]; then
    local padding=1
  else
    if [[ "$4" =~ ^[0-9]+$ ]]; then # Make sure it's a positive integer
      local padding=$4
    else
      local padding=1
    fi
  fi

  # Repeat a string n times
  repeat_string() {
    if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ "$2" -eq 0 ]]; then
      return
    fi
    printf "%0.s$1" $(seq $2)
  }

  clean_string() {
    local r=$(($required_spaces - 1))
    test "$r" -lt 1 && r=1
    echo "$1" | sed -E \
      -e '/^\s*$/d'               `# Delete blank lines` \
      -e 's/([ ]{'$r'}[ ]+)/\t/g' `# Detect n spaces and replace with tab` \
      -e 's/^\s*//g'              `# Trim leading spaces` \
      -e 's/\s*$//g'              `# Trim trailing spaces`
  }

  # Set some default vars
  declare -a local column_length
  local required_spaces=2 # Spaces required as column separator
  local headers="$(clean_string "$1")"
  local body="$(clean_string "$2")"
  local output=''
  local show_top=1
  local show_middle=1
  local show_bottom=1
  local shorten_border=0
  local ps="$(repeat_string ' ' $padding)" # Padding spaces
  local tl='' # Top-left
  local tm='' # Top-Middle
  local tr='' # Top-Right
  local ml='' # Middle-Left
  local mm='' # Middle-Middle
  local mr='' # Middle-Right
  local bl='' # Bottom-Left
  local bm='' # Bottom-Middle
  local br='' # Bottom-Right
  local oh='' # Outer Horizontal Bar
  local ih='' # Inner Horizontal Bar
  local ov='' # Outer Vertical Bar
  local iv='' # Inner Vertical Bar

  # Set style type
  if [[ -z "$3" ]] || [[ "$3" -eq 1 ]]; then
    # ┌────┬────┐
    # │ ab │ cd │
    # ├────┼────┤
    # │ ef │ gh │
    # └────┴────┘
    tl='┌'
    tm='┬'
    tr='┐'
    ml='├'
    mm='┼'
    mr='┤'
    bl='└'
    bm='┴'
    br='┘'
    oh='─'
    ih='─'
    ov='│'
    iv='│'
  elif [[ "$3" -eq 2 ]]; then
    # ╔════╦════╗
    # ║ ab ║ cd ║
    # ╠════╬════╣
    # ║ ef ║ gh ║
    # ╚════╩════╝
    tl='╔'
    tm='╦'
    tr='╗'
    ml='╠'
    mm='╬'
    mr='╣'
    bl='╚'
    bm='╩'
    br='╝'
    oh='═'
    ih='═'
    ov='║'
    iv='║'
  elif [[ "$3" -eq 3 ]]; then
    # ╔════╤════╗
    # ║ ab │ cd ║
    # ╟────┼────╢
    # ║ ef │ gh ║
    # ╚════╧════╝
    tl='╔'
    tm='╤'
    tr='╗'
    ml='╟'
    mm='┼'
    mr='╢'
    bl='╚'
    bm='╧'
    br='╝'
    oh='═'
    ih='─'
    ov='║'
    iv='│'
  elif [[ "$3" -eq 4 ]]; then
    # ════ ════
    #  ab   cd
    # ════ ════
    #  ef   gh
    # ════ ════
    tm=$ps
    mm=$ps
    bm=$ps
    oh='═'
    ih='═'
    iv=$ps
  elif [[ "$3" -eq 5 ]]; then
    # ════ ════
    #  ab   cd
    # ──── ────
    #  ef   gh
    # ════ ════
    tm=$ps
    mm=$ps
    bm=$ps
    oh='═'
    ih='─'
    iv=$ps
  elif [[ "$3" -eq 6 ]]; then
    #  ab   cd
    # ──── ────
    #  ef   gh
    show_top=0
    show_bottom=0
    shorten_border=1
    ih='─'
  fi

  # Determine the maximum length of each column based on the data
  get_max_depth() {
    while IFS=$'\t' read -a line; do
      column=0
      for line in "${line[@]}"; do
        if [[ column_length[$column] -lt ${#line} ]]; then
          column_length[$column]=${#line}
        fi
        let column++
      done
    done <<< "$1"
  }

  # Add padding to the maximum length of each column
  pad_each_column() {
    for col_key in ${!column_length[@]}; do
      local col_len=${column_length[$col_key]}
      col_len=$(($col_len + ($padding * 2)))
      column_length[$col_key]=$col_len
    done
  }

  # Display the top line above the header
  header_top_line() {
    for column in ${!column_length[@]}; do
      if [[ $column -eq 0 ]]; then # if the column is the first one
        output+="$tl$(repeat_string "$oh" ${column_length[$column]})"
      elif [[ $column -le ${#column_length[@]} ]]; then # if the column is the not last one
        output+="$tm$(repeat_string "$oh" ${column_length[$column]})"
      fi
    done
    output+="$tr\n" # print top-right corner
  }

  # Display a line of data (header or body)
  process_data() {
    # Loop through each line of input creating an array of each column called $data
    while IFS=$'\t' read -a data; do
      for column in ${!column_length[@]}; do
        # Determine remaining padding: column length - (data length + padding (on both sides))
        local trailing_padding=$((${column_length[$column]} - (${#data[$column]} + ($padding * 2))))
        if [[ $column -eq 0 ]]; then
          output+="$ov"
        else
          output+="$iv"
        fi
        output+="$ps${data[$column]}$ps"
        output+="$(repeat_string " " $trailing_padding)"
      done
      output+="$ov\n"
    done <<< "$1"
  }

  # Display the line between the header and the body
  header_bottom_line() {
    for column in ${!column_length[@]}; do
      if [[ $column -eq 0 ]]; then # if the column is the first one
        output+="$ml"
      elif [[ $column -le ${#column_length[@]} ]]; then # if the column is the not last one
        output+="$mm"
      fi
      if [[ "$shorten_border" -eq 1 ]]; then
        output+="$ps$(repeat_string "$ih" $((${column_length[$column]} - ($padding * 2))))$ps"
      else
        output+=$(repeat_string "$ih" ${column_length[$column]})
      fi
    done
    output+="$mr\n"
  }

  # Display the bottom line after the body
  footer() {
    for column in ${!column_length[@]}; do
      if [[ $column -eq 0 ]]; then # if the column is the first one
        output+="$bl$(repeat_string "$oh" ${column_length[$column]})"
      elif [[ $column -le ${#column_length[@]} ]]; then # if the column is the not last one
        output+="$bm$(repeat_string "$oh" ${column_length[$column]})"
      fi
    done
    output+="$br\n" # print top-right corner
  }

  # Define max depths for each column by processing input
  get_max_depth "$headers"
  get_max_depth "$body"

  # Add padding to the max depths
  pad_each_column

  # Generate the Header
  [[ "$show_top" -eq 1 ]] && header_top_line
  process_data "$headers"
  [[ "$show_middle" -eq 1 ]] && header_bottom_line

  # Generate the Body
  process_data "$body"
  [[ "$show_bottom" -eq 1 ]] && footer

  # Display the final output
  printf "$output"
}
