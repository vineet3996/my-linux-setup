#!/bin/bash



read -p "Please enter your username: " target_user;

if id -u "$target_user" >/dev/null 2>&1; then
    echo "User $target_user exists! Proceeding.. ";
else
    echo 'The username you entered does not seem to exist.';
    exit 1;
fi

# function to run command as non-root user
run_as_user() {
	sudo -u $target_user bash -c "$1";
}

run_as_user "unzip android-studio* -d /usr/local/"

run_as_user "cp desktopFiles/android-studio.desktop /home/${target_user}/.local/share/applications"

run_as_user "unzip platform-tools* -d /home/${target_user}/Android/Sdk/"
