#!/bin/zsh

# $1 in
function pio_topdf() {
    echo "Converting $1"

    docker run --rm \
        --volume "$(pwd):/data" \
        --user $(id -u):$(id -g) \
        pandoc/extra "$1" -o "$1.pdf" --template eisvogel --listings
}
