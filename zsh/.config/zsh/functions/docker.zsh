#!/bin/zsh

function docker_prune_all() {
    docker container prune
    docker volume prune -a
    docker image prune -a
    docker network prune
}
