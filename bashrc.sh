#!/usr/bin/env bash

export LS_COLORS="di=34:ln=36:so=32:pi=33:ex=32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"

nama="Pengguna"
zona_waktu="Asia/Makassar"

#INSTALL FIGLET DAHULU UNTUK HASIL MEMUASKAN. DENGAN CARA :

#pkg update && pkg upgrade -y && pkg install figlet
#jika ada muncul pilihan saat proses diatas
#maka tekan enter enter saja

#membuat file .hushlogin agar tampilan welcome dari termux tidak ada
if [ ! -e "$HOME/.hushlogin" ]; then
    touch "$HOME/.hushlogin"
    echo -e "\n.hushlogin berhasil dibuat."
#else
    #echo ".hushlogin sudah ada."
fi


# waktu indonesia
#daftar_hari=("" "Senin" "Selasa" "Rabu" "Kamis" "Jumat" "Sabtu" "Minggu")
#daftar_bulan=("" "Januari" "Februari" "Maret" "April" "Mei" "Juni" "Juli" "Agustus" "September" "Oktober" "November" "Desember")

# Diubah menjadi fungsi agar jamnya real-time setiap kali dipanggil
waktu_indo() {
    local daftar_hari=("" "Senin" "Selasa" "Rabu" "Kamis" "Jumat" "Sabtu" "Minggu")
    local daftar_bulan=("" "Januari" "Februari" "Maret" "April" "Mei" "Juni" "Juli" "Agustus" "September" "Oktober" "November" "Desember")
    local hari_indo=$(TZ="$zona_waktu" date +%u)
    local bulan_indo=$(TZ="$zona_waktu" date +%-m)
    printf "%s, %s %s %s | %s\n" "${daftar_hari[$hari_indo]}" "$(TZ="$zona_waktu" date +%d)" "${daftar_bulan[$bulan_indo]}" "$(TZ="$zona_waktu" date +%Y)" "$(TZ="$zona_waktu" date +%H:%M:%S)"
}

# Optimasi PROMPT_COMMAND ke dalam fungsi (Simbol @ dan warnanya tidak diubah sama sekali)
atur_prompt() {
    local EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ]; then
        PS1="\[\e[1;32m\][✓] \[\e[0;36m\]\u\[\e[0m\]\[\e[38;5;250m\]@\[\e[90m\]${nama}\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\] \$ "
    else
        PS1="\[\e[1;31m\][✗ $EXIT_STATUS] \[\e[0;36m\]\u\[\e[0m\]\[\e[38;5;250m\]@\[\e[90m\]${nama}\[\e[0m\] \[\e[0;32m\]\w\[\e[0m\] \$ "
    fi

}
PROMPT_COMMAND=atur_prompt

# Loop untuk memuat semua skrip di dalam folder ~/.rc
# Pastikan folder ~/.rc itu ada
for f in ~/.rc/*.sh; do
    [ -f "$f" ] && source "$f"
done

# Cek apakah sudah dimuat agar tidak berjalan 2x saat di-source
if [ -z "$_BASHRC_LOADED" ]; then
    #export _BASHRC_LOADED=1

    # Membungkus logika sapaan ke dalam fungsi agar variabelnya (JAM, SAPAAN) menjadi local
    tampilkan_sapaan() {
        #clear

        # Menampilkan logo dengan pengecekan perintah figlet & blackout-down
        if command -v figlet >/dev/null 2>&1 && command -v blackout-down >/dev/null 2>&1; then
            figlet -f small "halo ${nama}" | blackout-down
        elif command -v figlet >/dev/null 2>&1; then
            figlet -f small "halo ${nama}"
        #else
            #printf "halo %s\n" "${nama}"
        fi

        # 1. Menentukan zona waktu dan mengambil angka jam (00-23)
        local JAM=$(TZ="$zona_waktu" date +%H)
        local SAPAAN=""

        # 2. Logika if-else untuk menentukan waktu
        if [ "$JAM" -ge 3 ] && [ "$JAM" -le 10 ]; then
            SAPAAN="selamat pagi"
        elif [ "$JAM" -ge 11 ] && [ "$JAM" -le 14 ]; then
            SAPAAN="selamat siang"
        elif [ "$JAM" -ge 15 ] && [ "$JAM" -le 17 ]; then
            SAPAAN="selamat sore"
        else
            SAPAAN="selamat malam"
        fi

        # 4. Menampilkan teks sapaan dinamis dengan printf & pengecekan blackout-r
        if command -v blackout-r >/dev/null 2>&1; then
            printf "\nhalo! %s %s, atau user %s.\n" "$SAPAAN" "${nama}" "$(whoami)" | blackout-r
        else
            printf "\nhalo! %s %s, atau user %s.\n" "$SAPAAN" "${nama}" "$(whoami)"
        fi

        # Memanggil waktu sekarang dengan printf & pengecekan blackout
        if command -v blackout >/dev/null 2>&1; then
            printf "%s\n\n" "$(waktu_indo)" | blackout
        else
            printf "%s\n\n" "$(waktu_indo)"
        fi
    }

    # Menjalankan fungsi sapaan
    tampilkan_sapaan
fi
