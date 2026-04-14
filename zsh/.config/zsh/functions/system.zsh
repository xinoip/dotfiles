#!/bin/zsh

function pio_nuke() {
    # Nuke Antidote
    delf ~/.cache/antidote ~/.config/zsh/.zsh_plugins.zsh \
        ~/.config/zsh/.zcompdump ~/.config/zsh/.zcompdump.zwc \
        ~/3pp/antidote
    echo "Antidote nuked."

    # Nuke Tmux
    delf ~/.config/tmux/plugins
    echo "Tmux nuked."

    # Nuke Neovim
    delf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
    echo "Neovim nuked."

    echo "Restart both shell and tmux to see effects."
}

function pio_update() {
    if $PIOBUNTU; then
        pio_confirm "Update Ubuntu?" && sudo apt update && sudo apt upgrade && echo "Ubuntu updated."
    else
        pio_confirm "Update Void?" && xi -Su && echo "Void updated."

        pio_confirm "Update Void packages?" && cd ~/3pp/void-packages && git pull upstream master && xi -Su &&
            echo "Void packages updated."

        pio_confirm "Bump Void packages?" && ~/3pp/void-packages/personal/bump.sh && echo "Void packages bumped."
    fi

    if [[ -f /usr/bin/flatpak ]]; then
        pio_confirm "Update Flatpak?" && flatpak update && echo "Flatpak updated."
    fi
}

function xsearch() {
    if $PIOBUNTU; then
        apt-cache pkgnames "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'apt-cache show {1}' | xargs -ro sudo apt install
    else
        xbps-query -Rs "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'xbps-query -Rv {2} ' | awk '{print $2}' | xargs -ro xi
    fi
}

function xrm() {
    if $PIOBUNTU; then
        sudo apt-get autoremove $1
    else
        sudo xbps-remove -ROo $1 && flatpak uninstall --unused
    fi
}

function xhold() {
    if [ -n "$1" ]; then
        sudo xbps-pkgdb -m hold $1
    else
        xpkg -H
    fi
}

function xunhold() {
    sudo xbps-pkgdb -m unhold $1
}

function pio_toggle_sshd() {
    if $PIOBUNTU; then
        echo "Toggling sshd not supported on Ubuntu for now."
    else
        if [ -L /var/service/sshd ]; then
            echo "Disabling sshd..."
            sudo delf /var/service/sshd
        else
            echo "Enabling sshd..."
            sudo ln -s /etc/sv/sshd /var/service
        fi
    fi
}
