#!/bin/bash

# Check if sudo is installed
if command -v sudo &> /dev/null; then
    SUDO="sudo"
else
    SUDO=""
fi

# Update and upgrade system
echo "Updating and upgrading system..."
$SUDO apt update && $SUDO apt upgrade -y

# Download and install Folding@home client
echo "Downloading Folding@home client..."
wget https://download.foldingathome.org/releases/public/fah-client/debian-10-64bit/release/latest.deb

echo "Installing Folding@home client..."
$SUDO apt install ./latest.deb

# Prompt user to get their Folding@home token
echo "Get your Folding@home token here: https://v8-4.foldingathome.org/machines"

# Prompt for user inputs (token and machine name)
read -p "Enter your Folding@home account token: " account_token
read -p "Enter your machine's name: " machine_name

# Modify the config file
echo "Configuring Folding@home client..."
$SUDO bash -c "cat > /etc/fah-client/config.xml <<EOF
<config>
  <account-token v=\"$account_token\"/>
  <machine-name v=\"$machine_name\"/>
</config>
EOF"

# Restart Folding@home client
echo "Restarting Folding@home client..."
$SUDO systemctl restart fah-client

# Check if the service is enabled
if $SUDO systemctl is-enabled --quiet fah-client; then
    echo "Folding@home client service is enabled to start on boot."
else
    echo "WARNING: Folding@home client service is NOT enabled to start on boot."
    echo "You can enable it manually with: $SUDO systemctl enable fah-client"
fi

read -p "Do you want to clean up downloaded installation files? (Y/n): " remove_files
remove_files="${remove_files:-y}"  # Default to "y" if empty

if [ "$remove_files" == "y" ]; then
    rm latest.deb
    echo "Cleaned up installation files."
else
    echo "Keeping installation files."
fi

echo "Folding@home setup is complete!"
echo "https://v8-4.foldingathome.org/machines"
