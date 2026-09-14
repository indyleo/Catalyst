#!/bin/env bash

CONF_DIR="/etc/X11/xorg.conf.d"
CONF_FILE="$CONF_DIR/30-touchpad.conf"

# Function to configure touchpad to stay active while typing
function configure_touchpad() {
    if [[ -f "$CONF_FILE" ]]; then
        echo "Touchpad config already exists at $CONF_FILE, skipping."
        return
    fi

    echo "Configuring touchpad (disable-while-typing off)..."
    sudo mkdir -p "$CONF_DIR"
    sudo tee "$CONF_FILE" > /dev/null <<'EOF'
Section "InputClass"
    Identifier "libinput touchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "DisableWhileTyping" "false"
EndSection
EOF
    echo "Touchpad config written to $CONF_FILE. Log out/in (or restart X) to apply."
}

configure_touchpad
