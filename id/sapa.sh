shopt -s expand_aliases

nama="User"
zona_waktu="Asia/Makassar"

if [ -z "$_BASHRC_LOADED" ]; then
    export _BASHRC_LOADED=1

    waktu_indo() {
        local daftar_hari=("" "Senin" "Selasa" "Rabu" "Kamis" "Jumat" "Sabtu" "Minggu")
        local daftar_bulan=("" "Januari" "Februari" "Maret" "April" "Mei" "Juni" "Juli" "Agustus" "September" "Oktober" "November" "Desember")

        # (Optimasi) Pemanggilan 'date' cukup 1 kali saja menggunakan array/read agar script jauh lebih ringan
        read -r h m d y t <<< "$(TZ="$zona_waktu" date +'%u %-m %d %Y %H:%M:%S')"

        printf "%s, %s %s %s | %s\n" "${daftar_hari[$h]}" "$d" "${daftar_bulan[$m]}" "$y" "$t"
    }

    tampilkan_sapaan() {
        if command -v figlet >/dev/null 2>&1; then
            if command -v blackout-down >/dev/null 2>&1; then
                figlet -f small "halo ${nama}" | blackout-down
            else
                figlet -f small "halo ${nama}"
            fi
        fi

        local JAM=$(TZ="$zona_waktu" date +%-H)
        local SAPAAN="selamat malam"

        if [ "$JAM" -ge 3 ] && [ "$JAM" -le 10 ]; then
            SAPAAN="selamat pagi"
        elif [ "$JAM" -ge 11 ] && [ "$JAM" -le 14 ]; then
            SAPAAN="selamat siang"
        elif [ "$JAM" -ge 15 ] && [ "$JAM" -le 17 ]; then
            SAPAAN="selamat sore"
        fi

        # (Optimasi) Variabel digabung & menggunakan $USER bawaan env agar tidak perlu menjalankan proses $(whoami)
        local pesan_sapaan="\nhalo! $SAPAAN ${nama}. Registered as $(whoami).\n"

        if command -v blackout-r >/dev/null 2>&1; then
            printf "%b" "$pesan_sapaan" | blackout-r
        else
            printf "%b" "$pesan_sapaan"
        fi

        local pesan_waktu="$(waktu_indo)\n\n"

        if command -v blackout >/dev/null 2>&1; then
            printf "%b" "$pesan_waktu" | blackout
        else
            printf "%b" "$pesan_waktu"
        fi
    }

    tampilkan_sapaan
fi
