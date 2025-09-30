#!/bin/bash

# Script to create a root launcher for Hiddify on Fedora Silverblue

# Define variables
DESKTOP_FILE="$HOME/.local/share/applications/hiddify-root.desktop"
LAUNCHER_SCRIPT="$HOME/.local/bin/hiddify-root-launcher.sh"

# Create .local/bin directory if it doesn't exist
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"

# Create the launcher script
cat > "$LAUNCHER_SCRIPT" << 'EOF'
#!/bin/bash

# Capture current user's display variables
CURRENT_DISPLAY="$DISPLAY"
CURRENT_XAUTHORITY="$XAUTHORITY"
CURRENT_USER="$USER"

# If XAUTHORITY is not set, use default location
if [ -z "$CURRENT_XAUTHORITY" ]; then
    CURRENT_XAUTHORITY="$HOME/.Xauthority"
fi

# Use pkexec to run Hiddify with root privileges
# Pass the display environment properly
pkexec bash -c "export DISPLAY='$CURRENT_DISPLAY'; export XAUTHORITY='$CURRENT_XAUTHORITY'; xhost +SI:localuser:root > /dev/null 2>&1; /usr/bin/hiddify"
EOF

# Make the launcher script executable
chmod +x "$LAUNCHER_SCRIPT"

# Create the desktop entry
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Hiddify (Root)
Comment=Launch Hiddify with root privileges
Exec=$LAUNCHER_SCRIPT
Icon=hiddify
Terminal=false
Categories=Network;
StartupNotify=true
EOF

# Make the desktop file executable
chmod +x "$DESKTOP_FILE"

# Update desktop database
update-desktop-database "$HOME/.local/share/applications"

echo "Setup complete!"
echo "You can now find 'Hiddify (Root)' in your application menu"
echo "Or run it directly with: $LAUNCHER_SCRIPT"

