#!/bin/env bash
curl -fsSL https://tailscale.com/install.sh | sh
[[ -f ~/.zprofile ]] && . ~/.zprofile
sudo tailscale set --operator="$USER" --ssh
