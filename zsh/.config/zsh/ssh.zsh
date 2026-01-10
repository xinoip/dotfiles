#!/bin/zsh

SSH_ENV="$HOME/.ssh/pio_env"

function start_ssh_agent {
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  ssh-add
}

if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null

  if ! ps -p ${SSH_AGENT_PID} > /dev/null 2>&1; then
    start_ssh_agent
  fi
else
  start_ssh_agent
fi

if ! ssh-add -l > /dev/null 2>&1; then
  ssh-add ~/.ssh/pio_key 2>/dev/null
fi

