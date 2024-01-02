#!/bin/bash

# Go to the 
cd /tmp

# Download the latest Discord source archive
wget 'https://discord.com/api/download/stable?platform=linux&format=tar.gz' -O discord.tar.gz

# Extract the Discord source archive
tar -xzf discord.tar.gz -C /tmp/

# Replace the existing Discord installation with the new one
rm -rf /usr/share/discord
cp -r /tmp/Discord /usr/share/discord

# Remove the old Discord source archive
rm /tmp/discord.tar.gz && rm -rf /tmp/Discord/
