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

