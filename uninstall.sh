#!/bin/bash

read -p "Are you sure you want to uninstall? [y/n]: " ans
if [ "$ans" = "y" ] || [ "$ans" = "Y" ]; then
        echo "Starting uninstallation..."

        if [ -f ~/.bashrc.bak ]; then
                mv ~/.bashrc.bak ~/.bashrc
                echo "[✓] File .bashrc restored."
        else
                rm -f ~/.bashrc
                echo "[!] .bashrc.bak not found, .bashrc removed."
        fi

        rm -rf ~/.rc
        rm -f ~/.hushlogin
        rm -f ~/.config/starship.toml
        rm -f ~/.termux/colors.properties
        rm -f ~/.termux/font.ttf
        rm -f ~/.cache/ls_colors.sh ~/.cache/starship_init.* ~/.cache/starship_node_ver ~/.cache/whoami 2>/dev/null

        command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings

        echo "Uninstall completed! Please re-open your terminal."
else
        echo "Process cancelled."
        exit 0
fi
