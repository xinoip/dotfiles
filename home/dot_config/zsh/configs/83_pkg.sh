# Search system packages interactively.
xsearch() {
    if $PIOBUNTU; then
        apt-cache pkgnames "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'apt-cache show {1}' | xargs -ro sudo apt install
    else
        xbps-query -Rs "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'xbps-query -Rv {2} ' | awk '{print $2}' | xargs -ro xi
    fi
}

# Remove system packages, purgin everthing related.
xrm() {
    if $PIOBUNTU; then
        sudo apt-get autoremove $1
    else
        sudo xbps-remove -ROo $1 && flatpak uninstall --unused
    fi
}

# Hold a package to prevent updates.
xhold() {
    if [ -n "$1" ]; then
        sudo xbps-pkgdb -m hold $1
    else
        xpkg -H
    fi
}

# Unhold a package to resume updates.
xunhold() {
    sudo xbps-pkgdb -m unhold $1
}

# Prune Docker images, containers, volumes, and networks.
pio_docker_prune() {
    pio_helper_confirm "Prune Docker images?" && docker image prune -a
    pio_helper_confirm "Prune Docker containers?" && docker container prune
    pio_helper_confirm "Prune Docker volumes?" && docker volume prune -a
    pio_helper_confirm "Prune Docker networks?" && docker network prune
}

# Update system packages.
pio_update() {
    if $PIOBUNTU; then
        pio_helper_confirm "Update Ubuntu?" && sudo apt update && sudo apt upgrade && echo "Ubuntu updated."
    else
        pio_helper_confirm "Update Void?" &&
            xi -Su &&
            cd "$HOME/3pp/void-packages" &&
            ./personal/update.sh &&
            echo "Void updated."
    fi

    if [[ -f /usr/bin/flatpak ]]; then
        pio_helper_confirm "Update Flatpak?" && flatpak update && echo "Flatpak updated."
    fi
}

# Toggle SSH daemon.
pio_toggle_sshd() {
    pio_void_toggle_service sshd
}

# Toggle Tailscale daemon.
pio_toggle_tailscale() {
    pio_void_toggle_service tailscaled
}
