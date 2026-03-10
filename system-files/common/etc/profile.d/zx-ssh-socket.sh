#!/bin/bash

if [[ -z "$SSH_AUTH_SOCK" ]]; then
  export SOCKET_PATH="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi