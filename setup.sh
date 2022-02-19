#!/bin/bash

RED='\033[0;31m';
NC='\033[0m'; # No Color
GREEN='\033[0;32m';
YELLOW='\033[1;33m';

CWD=`pwd`;

delay_after_message=3;

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with sudo (sudo -i)" 
   exit 1
fi

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


# run_as_user "touch test.txt"


REQUIRED_PKG="flatpak"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
	printf "${YELLOW}Flatpak is not installed. Installing..${NC}\n";
	sleep $delay_after_message;
	apt update -y
	apt install flatpak -y
	apt install gnome-software-plugin-flatpak -y
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	printf "${GREEN}flatpak was installed, but requires a restart. ${NC}\nPlease reboot your computer and run this script again to proceed.\n"
	exit 1;
fi

apt update;


#Install Z Shell
printf "${YELLOW}Installing ZSH (Shell)${NC}\n";
sleep $delay_after_message;
apt install zsh -y
sleep 2;
chsh -s /bin/zsh


#install kitty and configure
printf "${RED}Installing and configuring Kitty terminal${NC}\n";
sleep $delay_after_message;
apt install kitty -y
run_as_user "mkdir -p ~/.config/kitty && cp kitty/*.conf ~/.config/kitty/";

#set kitty as default browser
update-alternatives --config x-terminal-emulator
gsettings set org.gnome.desktop.default-applications.terminal exec kitty
gsettings set org.gnome.desktop.default-applications.terminal exec-args ""


# Remove thunderbird
printf "${RED}Removing thunderbird completely${NC}\n";
sleep $delay_after_message;
apt-get purge thunderbird* -y

# Some basic shell utlities
printf "${YELLOW}Installing git, curl ${NC}\n";
sleep $delay_after_message;
apt install git -y
apt install curl -y
#apt install preload -y

printf "${YELLOW}Installing stacer.. ${NC}\n";
sleep $delay_after_message;
apt install stacer -y

# Enable Nautilus type-head (instead of search):
printf "${YELLOW}Enabling nautilus typeahead${NC}\n";
sleep $delay_after_message;
add-apt-repository ppa:lubomir-brindza/nautilus-typeahead -y

#Install Node Version Manager
#printf "${YELLOW}Installing Node Version Manager${NC}\n";
#sleep $delay_after_message;
#run_as_user "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh";

printf "${YELLOW}Installing Latest LTS Version of NodeJS${NC}\n";
sleep $delay_after_message;
#run_as_user "source /home/${target_user}/.zshrc && nvm install --lts";
apt install nodejs -y

#install surfshark-vpn
printf "${YELLOW}Installing surfshark VPN - Manual login required later${NC}\n";
sleep $delay_after_message;
wget https://ocean.surfshark.com/debian/pool/main/s/surfshark-release/surfshark-release_1.0.0-2_amd64.deb
dpkg -i surfshark-release_1.0.0-2_amd64.deb
sudo apt-get update
apt-get install surfshark-vpn

#Install VIM
printf "${YELLOW}Installing VIM${NC}\n";
sleep $delay_after_message;
apt install vim -y

#Copy my zsh files and vim dot files
run_as_user "cp -f dot-files/* /home/${target_user}/";


#Install z.lua
#printf "${YELLOW}Setting up z.lua${NC}\n";
#sleep $delay_after_message;
#apt install lua5.1 -y
#run_as_user "mkdir ~/scripts && cd ~/scripts";
#run_as_user "git clone --depth=1 https://github.com/skywind3000/z.lua";
#run_as_user "mv z.lua /home/${target_user}/.z-lua";
#run_as_user "eval '\$(lua /home/${target_user}/.z-lua/z.lua --init zsh)' >> /home/${target_user}/.zshrc";

#Setting up Powerline
printf "${YELLOW}Installing and Setting up Powerline and Powerline Fonts${NC}\n";
apt-get install powerline -y
run_as_user "mkdir -p /home/${target_user}/.fonts";
run_as_user "cp powerline-fonts/* /home/${target_user}/.fonts/";

run_as_user "git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /home/${target_user}/.oh-my-zsh";
#run_as_user "cat /home/${target_user}/.oh-my-zsh/templates/zshrc.zsh-template >> /home/${target_user}/.zshrc";
run_as_user "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/${target_user}/.oh-my-zsh/custom/themes/powerlevel10k";
run_as_user "sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/' /home/${target_user}/.zshrc";
#run_as_user "echo 'bindkey -v' >> /home/${target_user}/.zshrc";

#Install Pop OS Splash Screen
printf "${YELLOW}Setting up PopOS Splash Screen${NC}\n";
sleep $delay_after_message;
apt install plymouth-theme-pop-logo
update-alternatives --set default.plymouth /usr/share/plymouth/themes/pop-logo/pop-logo.plymouth
kernelstub -a splash
kernelstub -v

#Install inkscape  
printf "${YELLOW}Installing Inkscape${NC}\n";
sleep $delay_after_message;
apt install inkscape -y

#lm-sensors
printf "${YELLOW}Installing lm-sensors${NC}\n";
sleep $delay_after_message;
apt install lm-sensors -y
sensors-detect --auto

# Gnome tweak tool
printf "${YELLOW}Installing gnome-tweak-tool${NC}\n";
sleep $delay_after_message;
apt install gnome-tweaks -y;

#Docker
#printf "${YELLOW}Installing Docker ${NC}\n";
#sleep $delay_after_message;
#apt install docker.io -y
#systemctl enable --now docker
#usermod -aG docker $target_user;

#Install Open-SSH Server
printf "${YELLOW}Installing OpenSSH Server ${NC}\n";
sleep $delay_after_message;
apt install openssh-server -y
systemctl enable ssh
systemctl start ssh

#Install Chromium
printf "${YELLOW}Installing chromium-browser${NC}\n";
sleep $delay_after_message;
apt install chromium-browser -y

#Install Librewolf
printf "${YELLOW}Installing Librewolf-browser${NC}\n";
sleep $delay_after_message;
apt install librewolf -y

#Install neofetch
printf "${YELLOW}Installing neofetch${NC}\n";
sleep $delay_after_message;
apt install neofetch -y

#Install calibre
printf "${YELLOW}Installing calibre${NC}\n";
sleep $delay_after_message;
apt install calibre -y

#Install VS-code
printf "${YELLOW}Installing VSCode${NC}\n";
sleep $delay_after_message;
apt install code -y

#Install Alacritty
#printf "${YELLOW}Installing Alacritty (terminal)${NC}\n";
#sleep $delay_after_message;
#apt install alacritty -y
#run_as_user "mkdir -p ~/.config/alacritty && cp alacritty.yml ~/.config/alacritty/";

#Change Theme to WhiteSur Dark
printf "${YELLOW}Installing WhiteSur-dark theme${NC}\n";
sleep $delay_after_message;
run_as_user "cp white-sur-wallpaper.png ~/Pictures";
run_as_user "gsettings set org.gnome.desktop.background picture-uri file:////home/${target_user}/Pictures/white-sur-wallpaper.jpg";
run_as_user "unzip WhiteSur-dark.zip -d /home/${target_user}/.themes/";
run_as_user "unzip WhiteSur-icons-patched.zip -d /home/${target_user}/.icons/";
run_as_user "gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-dark'";
printf "${YELLOW}WhiteSur was installed, but for better results, download the User Themes gnome extension and use the tweak tool to change shell theme to WhiteSur as well.${NC}\n";
sleep $delay_after_message;

printf "${YELLOW}install caffine for Laptop ***purge it if not needed on desktop***${NC}\n";
sleep $delay_after_message;
apt install -y caffeine

printf "${YELLOW}Install VLC player${NC}\n";
sleep $delay_after_message;
apt install -y vlc

printf "${YELLOW}Install prerequisits for Gnome Shell Extentions${NC}\n";
sleep $delay_after_message;
apt install gnome-shell-extensions -y
#apt install chrome-gnome-shell -y

#flutter, android studio in separate script 
run_as_user "mkdir /home/${target_user}/flutter-stable";
run_as_user "git clone https://github.com/flutter/flutter.git -b stable /home/${target_user}/flutter-stable"


# printf "${GREEN}Basic settings done, proceeding to install bigger softwares (Like WebStorm, Android Studio etc) using flatpak${NC}\n";
# sleep $delay_after_message;

# run_as_user "flatpak install webstorm -y";
# run_as_user "flatpak install androidstudio -y";


apt dist-upgrade -y;
chsh -s /bin/zsh
update-initramfs -u
