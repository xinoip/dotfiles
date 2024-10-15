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

## emptty

For autologin:

```sh
# edit /etc/emptty/conf
sudo groupadd nopasswdlogin
sudo usermod $USER -aG nopasswdlogin
```

## steam

Fix download speeds on steam client. Create `~/.steam/steam/steam_dev.cfg`:

```sh
@nClientDownloadEnableHTTP2PlatformLinux 0
@fDownloadRateImprovementToAddAnotherConnection 1.0
```

## npm global

Fix npm global installations to be used without sudo:

```sh
npm config set prefix "~/.local/npm-global"
```

## Void Linux

```sh
# partition
1G EFI @ /boot/EFI VFAT
48G Swap
*G Linux Root x86_64 @ / ext4

# get xtools
sudo xbps-install -Syu
sudo xbps-install -S xtools

# enable repos
xi void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
xi -Su

# locales
/etc/default/libc-locales
sudo xbps-reconfigure glibc-locales --force

# drivers
xi linux-firmware-amd vulkan-loader mesa-dri mesa-vulkan-radeon \
   mesa-vaapi mesa-vdpau
xi mesa-dri-32bit vulkan-loader-32bit mesa-vulkan-radeon-32bit
xi xpadneo xone
# intel laptop
xi tlp tlpui tlp-rdw
# headset from Sapd/HeadsetControl

# fonts
xi noto-fonts-ttf noto-fonts-cjk noto-fonts-emoji nerd-fonts
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf 
sudo xbps-reconfigure -f fontconfig

# ssd trim weekly
vim /etc/cron.weekly/fstrim
    #!/bin/sh
    fstrim /

# core
xi NetworkManager elogind
sudo rm /var/service/dhcpcd /var/service/wpa_supplicant
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/dbus /var/service

# pipewire
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
# autostart pipewire
sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart
xi qpwgraph

# desktop
xi gnome extension-manager
sudo ln -s /etc/sv/gdm /var/service

# setup xdg-dirs
cd ~
mkdir download picture
mkdir -p 3pp/pio-xdg
cd 3pp/pio-xdg
mkdir Desktop Documents Music Public Templates Videos 

# service logging
xi socklog-void
sudo ln -s /etc/sv/socklog-unix /var/service
sudo ln -s /etc/sv/nanoklogd /var/service
sudo usermod -aG socklog pio
# test with svlogtail

# dotfiles
git clone https://github.com/xinoip/dotfiles
git submodule update --init --recursive
xi stow
stow */
vim /etc/zsh/zshenv
    export ZDOTDIR=~/.config/zsh
chsh --shell /usr/bin/zsh
xi file-devel
go install github.com/doronbehar/pistol/cmd/pistol@latest
cargo install trashy

# void-packages
cd ~/3pp
git clone https://github.com/void-linux/void-packages.git --depth=1
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
# use xi to install while in void-packages dir

# software
xi vim neovim bottom man-pages-devel man-pages-posix zsh tealdeer \
   fzf xz lsd lf stow bat tmux cmake base-devel lolcat-c figlet \
   cowsay lazygit go cargo steam libgcc-32bit libstdc++-32bit \
   libdrm-32bit libglvnd-32bit mono 7zip 7zip-unrar delta \
   chromium tree unrar unzip kitty ripgrep gamemode MangoHud \
   clang llvm clang-tools-extra

# flatpak
xi flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub io.gitlab.librewolf-community
```
