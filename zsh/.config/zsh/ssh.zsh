#!/bin/zsh

# This script manages ssh-agent for zsh. In order to load keys into the agent, use ~/.ssh/config like following:
#
# Host *
#     AddKeysToAgent yes
#     IdentityFile ~/.ssh/pio_key
#
# AddKeysToAgent already lazily loads the keys into the agent.

SSH_ENV="$HOME/.ssh/pio_env"

function start_ssh_agent {
  ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
}

if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null

  if ! ps -p ${SSH_AGENT_PID} > /dev/null 2>&1; then
    start_ssh_agent
  fi
else
  start_ssh_agent
fi

