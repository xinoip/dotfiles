# dotfiles

My personal dotfiles for linux systems (mainly void linux).

## Activate All

Using stow:

```sh
stow */
```

## ZSH Requirements

Modify `/etc/zsh/zshenv`:

```sh
export ZDOTDIR=~/.config/zsh
```

Change default shell:

```sh
chsh --shell /usr/bin/zsh
```

## XDG Requirements

Create XDG directories:

```sh
cd ~
mkdir download picture
mkdir -p 3pp/pio-xdg
cd 3pp/pio-xdg
mkdir Desktop Documents Music Public Templates Videos 
```

## Void Linux

```sh
# setup network
ln -s /etc/sv/dhcpcd /var/service
ping voidlinux.org

# update system
sudo xbps-install -Syu

# will use xtools from here on
sudo xbps-install -Syu xtools

# hardware all amd
xi linux-firmware-amd mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi mesa-vdpau 
# xbox gamepad
xi xpadneo xone 
# steelseries arctis headset
# build from git Sapd/HeadsetControl

# software: desktop common
xi emptty dbus elogind dbus-elogind polkit xorg-fonts gvfs handlr xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs socklog-void
# software: desktop wayland
xi sway xdg-desktop-portal-wlr qt5-wayland qt6-wayland
# software: general
xi vim neovim bottom man-pages-devel man-pages-posix void-repo-nonfree zsh kitty git firefox tealdeer fzf curl wget xz lsd lf stow bat tmux cmake base-devel lolcat-c figlet cowsay lazygit go cargo nerd-fonts openrgb font-awesome font-awesome5 font-awesome6 gammastep gammastep-indicator waybar steam void-repo-multilib void-repo-multilib-nonfree libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mesa-dri-32bit mono grim slurp swappy wdisplays pavucontrol 7zip 7zip-unrar chromium evince nwg-look tree unrar unzip thunar wofi
fc-cache -fv
fc-list
# change network setup
xi NetworkManager
sudo rm /var/service/dhcpcd
sudo ln -s /etc/sv/NetworkManager /var/service/
# setup pipewire
xi pipewire
mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/

# bootstrap all void packages
mkdir 3pp
cd 3pp
git clone https://github.com/void-linux/void-packages.git --depth=1
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
# use xi to install while in void-packages dir

# enable services
# dbus starts elogind, so dont run elogind as service
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/polkitd /var/service
sudo ln -s /etc/sv/emptty /var/service
sudo ln -s /etc/sv/socklog-unix /var/service
sudo ln -s /etc/sv/nanoklogd /var/service

# improve fonts
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo xbps-reconfigure -f fontconfig

# setup dotfiles
git clone https://github.com/xinoip/dotfiles
# need pistol as file previewer for lf 
xi file-devel
go install github.com/doronbehar/pistol/cmd/pistol@latest
# trash bin program
cargo install trashy
```
