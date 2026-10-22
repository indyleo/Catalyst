echo "Compiling lf-filemanager..."
gcc -O2 -Wall -o ./lf-filemanager lf-filemanager.c $(pkg-config --cflags --libs dbus-1)

echo "Installing lf-filemanager..."
install -Dm755 lf-filemanager ~/.local/bin/lf-filemanager

echo "Done"
