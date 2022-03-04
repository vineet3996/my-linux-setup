# Automatic setup script for Linux (Debian based distros with gnome)

I run this script on a fresh install of Linux, (Mostly Debian based distributions like Ubuntu or Pop!_OS etc) so that it sets everything up for me and I am ready to work..

When executed, it installs: 

* flatpak
* *Completely removes thunderbird*
* git, curl (used for network attached storage).
* zsh (with `oh-my-zsh` and `powerlevel10k` theme)
* PopOS Animated Splash Screen (Looks like this: https://www.reddit.com/r/pop_os/comments/jwn4se/psa_pop_os_boot_popup_logo/)
* nautilus (with typeahead support)
* openssh-server
* kitty terminal - with my conf file
* latest LTS version of NodeJS and NPM
* vim
* Inkscape
* lm-sensors
* gnome-tweak-tool
* docker - not active
* Chromium Browser
* prerequisites of Gnome shell extensions
* WebStorm - inactive
* Android Studio - inactive
* WhiteSur GTK+Icon theme.
* Copy my .vimrc and .zshrc

And finally upgrades all the packages in the system to the latest versions.

To run the script, simply type `sudo -i` enter your password. Navigate to the directory where you cloned the repository and then run `./script.sh`.
Then restart the computer for the change to take effect. Once you restart and open terminal, you will be prompted to configure the `powerlevel0k` theme. Just follow the prompts and set according to your liking.

Of course this exact list of softwares isn't probably what fit your needs, but you can fork this repo and use it as a template to adjust based on your own needs.


