#!/bin/zsh

function detect_theme() {
    # KDE Plasma
    if command -v plasma-apply-colorscheme &>/dev/null; then
        local theme_list=$(plasma-apply-colorscheme -l 2>/dev/null)
        local current_theme=$(echo "$theme_list" | grep -E '\*.*current' | sed 's/\*//g' | awk '{print $1}')

        if [[ "$current_theme" =~ [Ll]ight ]]; then
            echo "light"
            return
        elif [[ "$current_theme" =~ [Dd]ark ]]; then
            echo "dark"
            return
        fi
    fi

    # Default
    echo "dark"
}

# function fzf_with_theme() {
#     local initial_fzf_default_opts="$FZF_DEFAULT_OPTS"
#     local theme=$(detect_theme)
#     if [[ "$theme" == "light" ]]; then
#         export FZF_DEFAULT_OPTS="$initial_fzf_default_opts \
#       --highlight-line \
#       --info=inline-right \
#       --ansi \
#       --layout=reverse \
#       --border=none \
#       --color=bg+:#ebebeb \
#       --color=bg:#faf9f5 \
#       --color=border:#000000 \
#       --color=fg:#3d3d3d \
#       --color=fg+:#000000 \
#       --color=gutter:#faf9f5 \
#       --color=header:#000000 \
#       --color=hl+:#b07700 \
#       --color=hl:#b07700 \
#       --color=info:#969ba5 \
#       --color=marker:#ca0043 \
#       --color=pointer:#000000 \
#       --color=prompt:#000000 \
#       --color=query:#101010:regular \
#       --color=scrollbar:#000000 \
#       --color=separator:#000000 \
#       --color=spinner:#969ba5 \
#       "
#     else
#         export FZF_DEFAULT_OPTS="$initial_fzf_default_opts \
#       --highlight-line \
#       --info=inline-right \
#       --ansi \
#       --layout=reverse \
#       --border=none \
#       --color=bg+:#272727 \
#       --color=bg:#000000 \
#       --color=border:#ffffff \
#       --color=fg:#b0b0b0 \
#       --color=fg+:#ffffff \
#       --color=gutter:#101010 \
#       --color=header:#ffffff \
#       --color=hl+:#d9ba73 \
#       --color=hl:#d9ba73 \
#       --color=info:#50585d \
#       --color=marker:#ff7676 \
#       --color=pointer:#ffffff \
#       --color=prompt:#ffffff \
#       --color=query:#b0b0b0:regular \
#       --color=scrollbar:#b0b0b0 \
#       --color=separator:#ffffff \
#       --color=spinner:#50585d \
#       "
#     fi
#     # fzf "$@"
# }
# # alias fzf=fzf_with_theme

function setup_theme() {
    local initial_fzf_default_opts="$FZF_DEFAULT_OPTS"
    local theme=$(detect_theme)
    if [[ "$theme" == "light" ]]; then
        export FZF_DEFAULT_OPTS="$initial_fzf_default_opts \
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:#ebebeb \
      --color=bg:#faf9f5 \
      --color=border:#000000 \
      --color=fg:#3d3d3d \
      --color=fg+:#000000 \
      --color=gutter:#faf9f5 \
      --color=header:#000000 \
      --color=hl+:#b07700 \
      --color=hl:#b07700 \
      --color=info:#969ba5 \
      --color=marker:#ca0043 \
      --color=pointer:#000000 \
      --color=prompt:#000000 \
      --color=query:#101010:regular \
      --color=scrollbar:#000000 \
      --color=separator:#000000 \
      --color=spinner:#969ba5 \
      "
    else
        export FZF_DEFAULT_OPTS="$initial_fzf_default_opts \
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:#272727 \
      --color=bg:#000000 \
      --color=border:#ffffff \
      --color=fg:#b0b0b0 \
      --color=fg+:#ffffff \
      --color=gutter:#101010 \
      --color=header:#ffffff \
      --color=hl+:#d9ba73 \
      --color=hl:#d9ba73 \
      --color=info:#50585d \
      --color=marker:#ff7676 \
      --color=pointer:#ffffff \
      --color=prompt:#ffffff \
      --color=query:#b0b0b0:regular \
      --color=scrollbar:#b0b0b0 \
      --color=separator:#ffffff \
      --color=spinner:#50585d \
      "
    fi

    export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"
    export SUDO_PROMPT=$'\u001B[1m\u001B[47m\u001B[31m[sudo]\u001B[39m\u001B[49m\u001B[22m password for \u001B[1m\u001B[100m\u001B[33m%u@%h\u001B[39m\u001B[49m\u001B[22m: '
    pio_greet
}
