shopt -s expand_aliases

name="User"
timezone="America/Ohio"

if [ -z "$_BASHRC_LOADED" ]; then
    export _BASHRC_LOADED=1

    format_time() {
        local day_list=("" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
        local month_list=("" "January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December")

        # (Optimization) Calling 'date' only once using array/read makes the script much lighter
        read -r h m d y t <<< "$(TZ="$timezone" date +'%u %-m %d %Y %H:%M:%S')"

        printf "%s, %s %s %s | %s\n" "${day_list[$h]}" "$d" "${month_list[$m]}" "$y" "$t"
    }

    show_greeting() {
        if command -v figlet >/dev/null 2>&1; then
            if command -v blackout-down >/dev/null 2>&1; then
                figlet -f small "hello ${name}" | blackout-down
            else
                figlet -f small "hello ${name}"
            fi
        fi

        local HOUR=$(TZ="$timezone" date +%-H)
        local GREETING="good evening"

        if [ "$HOUR" -ge 3 ] && [ "$HOUR" -le 10 ]; then
            GREETING="good morning"
        elif [ "$HOUR" -ge 11 ] && [ "$HOUR" -le 14 ]; then
            GREETING="good afternoon"
        elif [ "$HOUR" -ge 15 ] && [ "$HOUR" -le 17 ]; then
            GREETING="good afternoon"
        fi

        # (Optimization) Variables combined & using built-in env $USER to avoid running $(whoami) process
        local greeting_message="\nhello! $GREETING ${name}. Registered as $(whoami).\n"

        if command -v blackout-r >/dev/null 2>&1; then
            printf "%b" "$greeting_message" | blackout-r
        else
            printf "%b" "$greeting_message"
        fi

        local time_message="$(format_time)\n\n"

        if command -v blackout >/dev/null 2>&1; then
            printf "%b" "$time_message" | blackout
        else
            printf "%b" "$time_message"
        fi
    }

    show_greeting
fi
