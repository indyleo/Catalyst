echo 'ACTION=="add|change", SUBSYSTEM=="leds", KERNEL=="*kbd_backlight", RUN+="/bin/chmod
666 /sys/class/leds/%k/brightness"' | sudo tee /etc/udev/rules.d/99-kbd-backlight.rules
sudo modprobe uinput                                                                                               4.006s
echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' \
    | sudo tee /etc/udev/rules.d/99-macro.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
