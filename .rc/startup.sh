# Buat folder cache di awal (jika belum ada)
mkdir -p ~/.cache

# 1. Caching Vivid (LS_COLORS)
if command -v vivid >/dev/null 2>&1; then
    if [ ! -f ~/.cache/ls_colors.sh ]; then
        echo "export LS_COLORS=\"$(vivid generate tokyonight-moon)\"" > ~/.cache/ls_colors.sh
    fi
    [ -f ~/.cache/ls_colors.sh ] && source ~/.cache/ls_colors.sh
fi

# 2. Caching Starship
if command -v starship >/dev/null 2>&1; then
    if [ -n "$ZSH_VERSION" ]; then
        if [ ! -f ~/.cache/starship_init.zsh ]; then
            starship init zsh --print-full-init > ~/.cache/starship_init.zsh
        fi
        [ -f ~/.cache/starship_init.zsh ] && source ~/.cache/starship_init.zsh
    elif [ -n "$BASH_VERSION" ]; then
        if [ ! -f ~/.cache/starship_init.bash ]; then
            starship init bash --print-full-init > ~/.cache/starship_init.bash
        fi
        [ -f ~/.cache/starship_init.bash ] && source ~/.cache/starship_init.bash
    fi
fi

# 3. Caching Node Version (Opsional, hanya berjalan jika Node.js terpasang)
if command -v node >/dev/null 2>&1; then
    if [ ! -f ~/.cache/starship_node_ver ]; then
        node -v > ~/.cache/starship_node_ver 2>/dev/null
    fi
    [ -f ~/.cache/starship_node_ver ] && export STARSHIP_NODE_VERSION=$(<~/.cache/starship_node_ver)
else
    rm -f ~/.cache/starship_node_ver 2>/dev/null
    unset STARSHIP_NODE_VERSION
fi

# 4. Zoxide Init
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# 5. Alias untuk update cache
alias recache='rm -f ~/.cache/ls_colors.sh ~/.cache/starship_init.* ~/.cache/starship_node_ver ~/.cache/whoami && echo -e "\e[32m[✓] Cache dibersihkan! Buka tab baru untuk re-cache.\e[0m"'
