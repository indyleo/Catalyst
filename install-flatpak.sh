#!/bin/env bash
FLATPAKS=(
    "com.github.tchx84.Flatseal"
    "org.prismlauncher.PrismLauncher"
    "xyz.xclicker.xclicker"
    "dev.vencord.Vesktop"
    "org.winehq.Wine"
    "net.davidotek.pupgui2"
    "com.github.Matoking.protontricks"
    "org.vinegarhq.Sober"
    "org.filezillaproject.Filezilla"
    "page.codeberg.JakobDev.jdNBTExplorer"
    "io.github.Faugus.faugus-launcher"
)

echo "Getting flathub repo..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for pak in "${FLATPAKS[@]}"; do
    if ! flatpak list | grep -i "$pak" &> /dev/null; then
        echo "Installing Flatpak: $pak"
        flatpak install --noninteractive "$pak"
    else
        echo "Flatpak already installed: $pak"
    fi
done

echo "Flatpaks installed"
