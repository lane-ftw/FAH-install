#!/bin/bash

# Update and upgrade system
echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

# Download and install Folding@home client
echo "Downloading Folding@home client..."
wget https://download.foldingathome.org/releases/public/fah-client/debian-10-64bit/release/latest.deb

echo "Installing Folding@home client..."
sudo apt install ./latest.deb

# Prompt user to get their Folding@home token
echo "Get your Folding@home token here: https://v8-4.foldingathome.org/machines"

# Prompt for user inputs (token and machine name)
read -p "Enter your Folding@home account token: " account_token
read -p "Enter your machine's name: " machine_name

# Modify the config file
echo "Configuring Folding@home client..."
sudo bash -c "cat > /etc/fah-client/config.xml <<EOF
<config>
  <account-token v=\"$account_token\"/>
  <machine-name v=\"$machine_name\"/>
</config>
EOF"

# Restart Folding@home client
echo "Restarting Folding@home client..."
sudo systemctl restart fah-client

# Check if the service is enabled
if systemctl is-enabled --quiet fah-client; then
    echo "Folding@home client service is enabled to start on boot."
else
    echo "WARNING: Folding@home client service is NOT enabled to start on boot."
    echo "You can enable it manually with: sudo systemctl enable fah-client"
fi

# clean up of the .deb package
read -p "Do you want to remove the downloaded .deb file? (Y/n): " remove_deb
remove_deb="${remove_deb:-y}"  # Default to "y" if empty

if [ "$remove_deb" == "y" ]; then
    rm latest.deb
    echo "Removed .deb file."
else
    echo "Keeping .deb file."
fi

echo "Folding@home setup is complete!"
echo "https://v8-4.foldingathome.org/machines"
