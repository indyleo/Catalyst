#!/bin/env bash
mv -v fastfetch git nvim lf tmux alacritty ohmyposh figletfonts mimeapps.list user-dirs.locale user-dirs.dirs ~/.config/

for f in ~/.bashrc ~/.profile ~/.zshenv ~/.zshrc; do
    if [ -f "$f" ]; then
        rm -v "$f"
        break
    fi
done

mv -v .profile .zshenv .zshrc .functionrc .aliasrc .hooksrc ~/
