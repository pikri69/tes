blackout() {
    while IFS= read -r line; do
        local len=${#line}
        for (( i=0; i<len; i++ )); do
            local char="${line:$i:1}"
            local color_val=255
            if (( len > 1 )); then
                color_val=$(( 100 + (155 * i / (len - 1)) ))
            fi
            printf "\e[38;2;${color_val};${color_val};${color_val}m%s" "$char"
        done
        printf "\e[0m\n"
    done
}

blackout_r() {
    while IFS= read -r line; do
        local len=${#line}
        for (( i=0; i<len; i++ )); do
            local char="${line:$i:1}"
            local color_val=255
            if (( len > 1 )); then
                color_val=$(( 255 - (155 * i / (len - 1)) ))
            fi
            printf "\e[38;2;${color_val};${color_val};${color_val}m%s" "$char"
        done
        printf "\e[0m\n"
    done
}

blackout_up() {
    local lines=()
    while IFS= read -r line; do
        lines+=("$line")
    done
    
    local num_lines=${#lines[@]}
    for (( j=0; j<num_lines; j++ )); do
        local color_val=255
        if (( num_lines > 1 )); then
            color_val=$(( 100 + (155 * j / (num_lines - 1)) ))
        fi
        printf "\e[38;2;${color_val};${color_val};${color_val}m%s\e[0m\n" "${lines[$j]}"
    done
}

blackout_down() {
    local lines=()
    while IFS= read -r line; do
        lines+=("$line")
    done
    
    local num_lines=${#lines[@]}
    for (( j=0; j<num_lines; j++ )); do
        local color_val=255
        if (( num_lines > 1 )); then
            color_val=$(( 255 - (155 * j / (num_lines - 1)) ))
        fi
        printf "\e[38;2;${color_val};${color_val};${color_val}m%s\e[0m\n" "${lines[$j]}"
    done
}

alias blackout-up="blackout_up"
alias blackout-down="blackout_down"
alias blackout-r="blackout_r"
