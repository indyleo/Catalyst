#!/bin/env bash
FLATPAKS=(
    "io.github.dweymouth.supersonic"
    "com.obsproject.Studio"
    "io.github.arunsivaramanneo.GPUViewer"
    "org.fedoraproject.MediaWriter"
    "com.chatterino.chatterino"
    "net.lutris.Lutris"
    "com.github.tchx84.Flatseal"
    "org.prismlauncher.PrismLauncher"
    "com.heroicgameslauncher.hgl"
    "xyz.xclicker.xclicker"
    "dev.vencord.Vesktop"
    "org.winehq.Wine"
    "com.usebottles.bottles"
    "net.davidotek.pupgui2"
    "org.fkoehler.KTailctl"
    "com.brave.Browser"
    "com.github.Matoking.protontricks"
    "org.vinegarhq.Sober"
    "io.unobserved.espansoGUI"
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
