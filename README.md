# My Dotfiles

My Dotfiles for my kde config for [Debian 13](https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-dvd/) or lfs with apt

# Other Settings/Themes

- Enable the Magic Lamp, Wobbaly Windows, Better Blur, and set scale to 0.60 for a nicer look
- Set Alacritty to have blur in Better Blur settings
- Add my Wallpapers as a slideshow for the wallpapers
- Set wallpaper folder as a slideshow for the lock screen
- Set Krunner to be in the center of the screen, and to use Meta+r as the hotkey to open it
- Set Meta+Return as the hotkey to open Alacritty
- Set Meta+d to open VeskTop
- Set Meta+f to open dolphin
- Set Meta+m to open supersonic
- Set Meta+q to close the current window
- Set Meta+b to open the browser

# EnvyControl

```bash
sudo python3 envycontrol.py -s nvidia --force-comp --coolbits 2
sudo reboot

```

# How to install

```bash
git clone https://github.com/indyleo/kdedots.git
cd kdedots
sudo ./install.sh
./usersetups.sh
```

# Weird Reminder

If you want to change your mouse setting on a gpro wirless x superlight you need to plug it in idk why
