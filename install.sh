#!/bin/bash

touch ~/.hushlogin
chmod +x .rc/* 2>/dev/null

if [ "$1" = "en" ]; then
        read -p "Continue? This action will replace your .bashrc [y/n]: " ans
        if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
                echo "Continuing process..."
                echo "Starting update & upgrade..."
                if ! pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"; then
                        echo "Error: Failed to update packages. Aborting installation."
                        exit 1
                fi

                # Eksekusi khusus versi English
                echo "Starting downloading package..."
                if ! pkg install eza starship vivid figlet -y; then
                        echo "Error: Failed to install required packages. Aborting installation."
                        exit 1
                fi

                echo "Starting to setup..."
                mkdir -p ~/.config ~/.rc ~/.termux

                cp -r .rc/* ~/.rc/ 2>/dev/null
                cp en/greet.sh ~/.rc/ 2>/dev/null
                chmod +x ~/.rc/*.sh 2>/dev/null

                [ -f ./starship.toml ] && cp ./starship.toml ~/.config/
                [ -f ./colors.properties ] && cp ./colors.properties ~/.termux/
                [ -f ./font.ttf ] && cp ./font.ttf ~/.termux/

                if [ -f ~/.bashrc ] && [ ! -f ~/.bashrc.bak ]; then
                        mv ~/.bashrc ~/.bashrc.bak
                fi
                cp bashrc.sh ~/.bashrc

                command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings
                echo "Installation completed!"
        else
                echo "Process canceled."
                exit 0
        fi

elif [ "$1" = "id" ]; then
        read -p "Lanjut? Tindakan ini akan menggantikan .bashrc Anda [y/n]: " ans
        if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
                echo "Melanjutkan proses..."
                echo "Memulai update & upgrade..."
                if ! pkg update && pkg upgrade -y -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef"; then
                        echo "Eror: Gagal memperbarui paket. Menghentikan instalasi."
                        exit 1
                fi

                # Eksekusi khusus versi Indonesia
                echo "Memulai mengunduh paket..."
                if ! pkg install eza starship vivid figlet -y; then
                        echo "Eror: Gagal mengunduh paket yang dibutuhkan. Menghentikan instalasi."
                        exit 1
                fi

                echo "Memulai penyetelan..."
                mkdir -p ~/.config ~/.rc ~/.termux

                cp -r .rc/* ~/.rc/ 2>/dev/null
                cp id/sapa.sh ~/.rc/ 2>/dev/null
                chmod +x ~/.rc/*.sh 2>/dev/null

                [ -f ./starship.toml ] && cp ./starship.toml ~/.config/
                [ -f ./colors.properties ] && cp ./colors.properties ~/.termux/
                [ -f ./font.ttf ] && cp ./font.ttf ~/.termux/

                if [ -f ~/.bashrc ] && [ ! -f ~/.bashrc.bak ]; then
                        mv ~/.bashrc ~/.bashrc.bak
                fi
                cp bashrc.sh ~/.bashrc

                command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings
                echo "Pemasangan selesai!"
        else
                echo "Proses dibatalkan."
                exit 0
        fi

else
        echo "Usage: ./install.sh [en|id]"
        exit 1
fi
