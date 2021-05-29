#!/bin/bash
red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"
function user {
	clear
	echo -e "${red}${bold}set name for your user${reset}"
	read name
	useradd -m $name
	clear
	echo -e "${red}${bold}set password for your user${reset}"
	passwd $name
}
function heyyy {
	clear
	pacman -S sudo
	EDITOR=nano visudo
}
function wm {
	clear
	echo -e "${red}${bold}should i install DE?
	1) yes
	2) no${reset}"
	read answr2
	[ "$answr2" == "1" ] && wmy
}
function wmy {
	clear
	echo -e "${red}${bold}set your DE
	1) plasma
	2) gnome
	3) cinnamon
	4) deepin
	5) mate
	6) budgie
	7) xfce
	8) enlightenment
	9) sway${reset}"
	read answr3
	[ "$answr3" == "1" ] && plasma
	[ "$answr3" == "2" ] && gnome
	[ "$answr3" == "3" ] && cinnamon
	[ "$answr3" == "4" ] && deepin
	[ "$answr3" == "5" ] && mate
	[ "$answr3" == "6" ] && budgie
	[ "$answr3" == "7" ] && xfce
	[ "$answr3" == "8" ] && enlightenment
	[ "$answr3" == "9" ] && sway
}
function budgie {
	clear
	pacman -S lxdm-gtk3 budgie-desktop
	systemctl enable lxdm
}
function enlightenment {
	clear
	pacman -S enlightenment lxdm-gtk3 terminology
	systemctl enable lxdm
}
function sway {
	clear
	pacman -S sway pulseaudio pamixer
}
function cinnamon {
	clear
	pacman -S cinnamon lxdm-gtk3
	systemctl enable lxdm
}
function deepin {
	clear
	pacman -S deepin
	systemctl enable lightdm
}
function plasma {
	clear
	pacman -S plasma-meta konsole dolphin kate plasma-wayland-session gwenview ark p7zip unrar unarchiver lzop lrzip okular
	systemctl enable sddm
	clear
	echo -e "${red}${bold}should i disable kde wallet?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && disable_wallet
}
function disable_wallet {
	mkdir /home/$name/.config
	chmod 777 /home/$name/.config
	echo "[Wallet]" >> /home/$name/.config/kwalletrc
	echo "Enabled=false" >> /home/$name/.config/kwalletrc
	chmod 777 /home/$name/.config/kwalletrc
}
function mate {
	clear
	pacman -S mate mate-extra lxdm-gtk3
	systemctl enable lxdm
}
function gnome {
	clear
	pacman -S gnome ffmpegthumbnailer gst-libav gst-plugins-ugly
	systemctl enable gdm
}
function xfce {
	clear
	pacman -S xfce4 lxdm-gtk3 xfce4-xkb-plugin mousepad xfce4-pulseaudio-plugin pavucontrol pulseaudio
	systemctl enable lxdm
}
function pack {
	clear
	echo -e "${red}${bold}should i install some additional packages?
	1) yes
	2) no${reset}"
	read pick
	[ "$pick" == "1" ] && installpack
}
function installpack {
	clear
	echo -e "${red}${bold}enter packages to install${reset}"
	read moar
	clear
	pacman -S $moar
}
function fstab {
	mv boot.mount /etc/systemd/system/
	ls | grep -w "home.mount" && mv home.mount /etc/systemd/system/
	cd /etc/systemd/system/
	systemctl enable boot.mount
	ls | grep -w "home.mount" && systemctl enable home.mount
	cd /
}
function doas {
	clear
	pacman -S opendoas
	ls /etc | grep -w "doas.conf" && rm /etc/doas.conf
	echo "permit persist $name as root" >> /etc/doas.conf
}
clear
fstab
clear
nano /etc/locale.gen
clear
locale-gen
clear
echo -e "${red}${bold}set your hostname${reset}"
echo -e "${red}${bold}to exit press CTRL+D twice${reset}"
cat > /etc/hostname
clear
echo -e "${red}${bold}set your root password${reset}"
passwd
clear
echo -e "${red}${bold}should i add user?
1) yes
2) no${reset}"
read answr
[ "$answr" == "1" ] && user
clear
echo -e "${red}${bold}should i enable dhcpcd?
1) yes
2) no${reset}"
read dhcp
[ "$dhcp" == "1" ] && systemctl enable dhcpcd
clear
echo -e "${red}${bold}what should i install?
1) sudo
2) doas
3) nothing${reset}"
read sdo
[ "$sdo" == "1" ] && heyyy
[ "$sdo" == "2" ] && doas
wm
clear
pack
ls | grep -w "encrypt" && (rm /etc/mkinitcpio.conf && mv mkinitcpio.conf /etc/ && mkinitcpio -P)
