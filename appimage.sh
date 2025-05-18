#!/bin/bash

# Creates the AppImage_Programs directory if it doesn't exist
echo "Checking to see if ~/AppImage_Programs exists"
if [ ! -d ~/AppImage_Programs ]; then  
  mkdir ~/AppImage_Programs/
  echo "Created directory!"
else
  echo "Directory already present"
fi

# Validate input file
if [ ! -f "$1" ]; then
  echo "Error: File '$1' does not exist!" >&2
  exit 1
fi

abs_path=$(realpath "$1")
abs_dir_location=$(dirname "$abs_path")  # Can be removed if unused

# Move the file to the AppImage_Programs folder
mv "$abs_path" ~/AppImage_Programs/
echo "Moved $1 to ~/AppImage_Programs"

base_name=$(basename "$1" .AppImage)
desktop_file="$HOME/.local/share/applications/${base_name}.desktop"

# .desktop file template
cat > "$desktop_file" <<EOF
[Desktop Entry]
Type=Application
Name=$base_name  # Use sanitized name instead of raw \$1
Comment=Custom AppImage Launcher
Exec=$HOME/AppImage_Programs/$(basename "$abs_path")
Icon=
EOF

# User confirmation check
echo "Do you want to modify the .desktop file?"
read -p "Continue? (y/n): " confirm

if [[ "$confirm" =~ [yY] ]]; then  # Fixed: Proper regex check
  nvim "$desktop_file" #add support for multiple editing programs
fi

# Grant execute permission
chmod +x ~/AppImage_Programs/"$(basename "$abs_path")"
echo "Granted execute permission for AppImage file"

# Update database
update-desktop-database ~/.local/share/applications/  
echo "Updated the desktop database!"
