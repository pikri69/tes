shopt -s expand_aliases
#for f in ~/.rc/*.sh; do [ -f "$f" ] && source "$f"; done

nama="Fiqri"
zona_waktu="Asia/Makassar"

if [ -z "$_BASHRC_LOADED" ]; then
    export _BASHRC_LOADED=1

    waktu_indo() {
        local daftar_hari=("" "Senin" "Selasa" "Rabu" "Kamis" "Jumat" "Sabtu" "Minggu")
        local daftar_bulan=("" "Januari" "Februari" "Maret" "April" "Mei" "Juni" "Juli" "Agustus" "September" "Oktober" "November" "Desember")
        local hari_indo=$(TZ="$zona_waktu" date +%u)
        local bulan_indo=$(TZ="$zona_waktu" date +%-m)
        printf "%s, %s %s %s | %s\n" "${daftar_hari[$hari_indo]}" "$(TZ="$zona_waktu" date +%d)" "${daftar_bulan[$bulan_indo]}" "$(TZ="$zona_waktu" date +%Y)" "$(TZ="$zona_waktu" date +%H:%M:%S)"
    }

    tampilkan_sapaan() {
        if command -v figlet >/dev/null 2>&1 && command -v blackout-down >/dev/null 2>&1; then
            figlet -f small "halo ${nama}" | blackout-down
        elif command -v figlet >/dev/null 2>&1; then
            figlet -f small "halo ${nama}"
        fi

        local JAM=$(TZ="$zona_waktu" date +%-H)
        local SAPAAN=""

        if [ "$JAM" -ge 3 ] && [ "$JAM" -le 10 ]; then
            SAPAAN="selamat pagi"
        elif [ "$JAM" -ge 11 ] && [ "$JAM" -le 14 ]; then
            SAPAAN="selamat siang"
        elif [ "$JAM" -ge 15 ] && [ "$JAM" -le 17 ]; then
            SAPAAN="selamat sore"
        else
            SAPAAN="selamat malam"
        fi

        if command -v blackout-r >/dev/null 2>&1; then
            printf "\nhalo! %s %s. Registered as %s.\n" "$SAPAAN" "${nama}" "$(whoami)" | blackout-r
        else
            printf "\nhalo! %s %s. Registered as%s.\n" "$SAPAAN" "${nama}" "$(whoami)"
        fi

        if command -v blackout >/dev/null 2>&1; then
            printf "%s\n\n" "$(waktu_indo)" | blackout
        else
            printf "%s\n\n" "$(waktu_indo)"
        fi
    }

    tampilkan_sapaan
fi
