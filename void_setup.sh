#!/bin/bash

set -e
set -o nounset

info() {
   local message="$1"
   local color="\033[1;33m" # Yellow
   echo -e "${color}[VOID_SETUP] ${message}\033[0m"
}

info "START"

info "System update"
sudo xbps-install -Syu
info "Get xtools"
sudo xbps-install -S xtools

info "Enable additional repos"
xi void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
xi -Su

info "AMD drivers"
xi linux-firmware-amd vulkan-loader mesa-dri mesa-vulkan-radeon mesa-vaapi mesa-vdpau mesa-dri-32bit vulkan-loader-32bit mesa-vulkan-radeon-32bit

# info "NVIDIA drivers"
# xi nvidia nvidia-libs-32bit vulkan-loader vulkan-loader-32bit
# sudo bash -c 'cat <<EOF > "/etc/modprobe.d/nvidia_drm.conf"
# options nvidia_drm modeset=1
# EOF'

# info "Intel drivers"
# xi linux-firmware-intel mesa-vulkan-intel intel-video-accel mesa-dri vulkan-loader mesa-vulkan-intel-32bit mesa-dri-32bit vulkan-loader-32bit
# info "Install intel ucode"

# TODO: check microcode support for intel & amd
# TODO: setup chrony

info "Gamepad drivers"
xi xpadneo xone

info "Fonts"
xi noto-fonts-ttf noto-fonts-cjk noto-fonts-emoji nerd-fonts

info "Improve font rendering"
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
sudo xbps-reconfigure -f fontconfig

info "SSD Trim weekly"
xi snooze
sudo ln -s /etc/sv/snooze-daily /var/service
sudo ln -s /etc/sv/snooze-weekly /var/service
sudo mkdir -p /etc/cron.weekly
sudo bash -c 'cat <<EOF > "/etc/cron.weekly/maintain"
#!/bin/sh
fstrim /
tldr --update
vkpurge rm all
EOF'
sudo chmod +x /etc/cron.weekly/maintain

info "Install elogind/dbus"
xi elogind
sudo ln -s /etc/sv/dbus /var/service

info "Install pipewire"
# qpwgraph may be installed too
xi pipewire
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
sudo mkdir -p /etc/xdg/autostart
sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart

info "Install KDE"
# emptty may be used instead of sddm
xi kde-plasma kde-baseapps dolphin kdegraphics-thumbnailers ffmpegthumbs ark spectacle xorg-minimal gwenview evince

info "Setup xdg-dirs"
cd ~
rm -rf Desktop Documents Music Public Templates Videos Downloads Pictures
mkdir -p download picture
mkdir -p 3pp/pio-xdg
cd 3pp/pio-xdg
mkdir Desktop Documents Music Public Templates Videos

info "Service logs"
xi socklog-void
sudo ln -s /etc/sv/socklog-unix /var/service
sudo ln -s /etc/sv/nanoklogd /var/service
sudo usermod -aG socklog $USER

info "Install software"
xi vim neovim bottom man-pages-devel man-pages-posix zsh tealdeer \
   fzf xz lsd lf stow bat tmux cmake base-devel lolcat-c figlet \
   cowsay lazygit go cargo steam libgcc-32bit libstdc++-32bit \
   libdrm-32bit libglvnd-32bit mono 7zip 7zip-unrar delta \
   chromium tree unrar unzip kitty ripgrep gamemode MangoHud \
   clang llvm clang-tools-extra firefox ufetch n docker lazydocker \
   easyeffects lsp-plugins vscode gamescope xrandr vsv dust \
   android-tools ninja gparted qbittorrent pandoc ImageMagick openrgb \
   nmap inetutils-telnet wireshark wireshark-qt powertop just wireguard-tools \
   fd wl-clipboard git-filter-repo baobab docker-buildx duf lshw mtr iotop \
   progress bind-utils termshark ipcalc bootchart2 procs unp jq asciinema \
   yazi tokei wiki-tui prelink trash-cli kdeconnect

info "Steam tinker launcher dependencies"
xi xdotool xprop xwininfo yad

# info "Battery health"
# xi tlp powertop
# sudo ln -s /etc/sv/tlp /var/service

info "Install Node"
N_PREFIX=$HOME/3pp/node n lts
xi pnpm

# info "Install latex plugins"
# xi texlive-bin
# sudo tlmgr install collection-latex collection-latexrecommended collection-basic

info "void-packages repo"
cd ~/3pp
git clone https://github.com/xinoip/void-packages.git --depth=1
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >>etc/conf

info "Build & Install additional void packages"
cd ~/3pp/void-packages
./xbps-src pkg brave-bin
xi brave-bin
./xbps-src pkg zen-browser
xi zen-browser
./xbps-src pkg android-studio
xi android-studio

info "Enable docker service"
sudo ln -s /etc/sv/docker /var/service

info "Setup docker group"
sudo usermod -aG docker $USER

info "Flatpak"
xi flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

info "Dotfiles"
cd ~
git clone https://github.com/xinoip/dotfiles
cd dotfiles
git submodule update --init --recursive
xi stow
rm -rf ~/.config/user-dirs.dirs
stow zsh nvim kitty tmux xdg git lazygit mangohud pulse tealdeer wget
sudo bash -c 'cat <<EOF >> "/etc/zsh/zshenv"
export ZDOTDIR=~/.config/zsh
EOF'
chsh --shell /usr/bin/zsh
info "Dotfiles configuration is done. Don't forget to change git remote url afterwards!"

info "Setup NTP"
xi chrony
sudo ln -s /etc/sv/chronyd /var/service

info "Setup Bitwarden"
flatpak install flathub com.bitwarden.desktop
sudo flatpak override --env=BITWARDEN_SSH_AUTH_SOCK=$HOME/.var/app/com.bitwarden.desktop/.bitwarden-ssh-agent.sock com.bitwarden.desktop

info "Setup flatpak apps"
flatpak install flathub net.davidotek.pupgui2

info "Setup bluetooth"
xi bluez libspa-bluetooth
sudo usermod -aG bluetooth $USER
sudo ln -s /etc/sv/bluetoothd /var/service

info "Optimize system"
xi gtk+ gtk+-32bit libICE libICE-32bit libnm libnm-32bit libopenal libopenal-32bit libpipewire libpipewire-32bit \
   SDL2 SDL2-32bit libva libva-32bit libvdpau libvdpau-32bit MangoHud-mangoapp
sudo bash -c 'cat <<EOF >> "/etc/security/limits.conf"
* hard nofile 524288
EOF'
sudo bash -c 'cat <<EOF >> "/etc/sysctl.conf"
vm.max_map_count=1048576
fs.inotify.max_user_instances = 256
EOF'
sudo sysctl -p

info "Switch to NetworkManager THIS MAY LOSE INTERNET"
xi NetworkManager
sudo rm -rf /var/service/dhcpcd /var/service/wpa_supplicant
sudo ln -s /etc/sv/NetworkManager /var/service

info "Enable display server"
sudo ln -s /etc/sv/sddm /var/service
