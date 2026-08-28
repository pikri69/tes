alias ls="eza --icons=auto --git --group-directories-first"

# 1. PERSIAPAN & SPINNER DI BACKGROUND
stty -echo </dev/tty 2>/dev/null
printf "\e[?25l"

(
    spin_chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    while true; do
        for char in "${spin_chars[@]}"; do
            printf "\r\e[36m%s\e[0m Loading..." "$char" >/dev/tty
            sleep 0.01
        done
    done
) &
SPIN_PID=$!
disown $SPIN_PID

# 2. PENCEGAT STDOUT (Matikan spinner begitu karakter pertama masuk)
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

# 3. PROSES UTAMA
if [ -d "$HOME/.rc" ]; then
    for file in "$HOME/.rc/"*.sh; do
        [ -r "$file" ] && source "$file"
    done
fi

# 4. KEMBALIKAN STDOUT & BERSIHKAN JIKA TIDAK ADA OUTPUT SAMA SEKALI
exec >&3 3>&-
kill -9 $SPIN_PID 2>/dev/null
printf "\r\e[K\e[?25h"
stty echo </dev/tty 2>/dev/null
