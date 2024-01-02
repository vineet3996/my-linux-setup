#!/bin/bash

# Has to be downloaded manually from the browser
mv /home/vt/Downloads/android-studio-*-linux.tar.gz /tmp/studio.tar.gz

# Go to the 
cd /tmp

# Extract the Discord source archive
tar -xzf studio.tar.gz -C /tmp/

# Replace the existing Discord installation with the new one
rm -rf /opt/android-studio
cp -r /tmp/android-studio /opt

# Remove the old Discord source archive
rm /tmp/studio.tar.gz && rm -rf /tmp/android-studio
