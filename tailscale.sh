#!/bin/env bash
curl -fsSL https://tailscale.com/install.sh | sh
[[ -f ~/.profile ]] || . ~/.profile
sudo tailscale set --operator="$USER"
