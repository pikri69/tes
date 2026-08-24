# spinner
stty -echo </dev/tty 2>/dev/null
printf "\e[?25l"

(
    spin_chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    while true; do
        for char in "${spin_chars[@]}"; do
            printf "\r\e[36m%s\e[0m Loading..." "$char" >/dev/tty
            sleep 0.05
        done
    done
) &
SPIN_PID=$!
disown $SPIN_PID

#
shopt -s expand_aliases
exec 3>&1

exec > >(
    if IFS= read -r -n 1 char 2>/dev/null || [ -n "$char" ]; then
        kill -9 $SPIN_PID 2>/dev/null
        printf "\r\e[K\e[?25h" >/dev/tty
        stty echo </dev/tty 2>/dev/null
        printf "%s" "$char" >&3
        cat >&3
    fi
)

# PROSES UTAMA
if [ -d "$HOME/.rc" ]; then
    for file in "$HOME/.rc/"*.sh; do
        [ -r "$file" ] && source "$file"
    done
fi

###
exec >&3 3>&-
sleep 0.02
kill -9 $SPIN_PID 2>/dev/null
printf "\r\e[K\e[?25h"
stty echo </dev/tty 2>/dev/null
