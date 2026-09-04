echo 'ACTION=="add|change", SUBSYSTEM=="leds", KERNEL=="*kbd_backlight", RUN+="/bin/chmod
666 /sys/class/leds/%k/brightness"' | sudo tee /etc/udev/rules.d/99-kbd-backlight.rules
sudo udevadm control --reload-rules
sudo udevadm trigger

