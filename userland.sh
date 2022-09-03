#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
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
function sudo_install {
	clear
	pacman -S sudo
	EDITOR=nano visudo
}
function install_desktop_enviroment {
	clear
	echo -e "${red}${bold}should I install desktop enviroment?
	1) yes
	2) no${reset}"
	read answr2
	[ "$answr2" == "1" ] && desktop_enviroment
}
function desktop_enviroment {
	clear
	echo -e "${red}${bold}set your desktop enviroment
	1) plasma
	2) gnome
	3) deepin
	4) cutefish
	5) budgie
	6) cinnamon
	7) mate
	8) xfce
	9) enlightenment
	10) lxde
	11) lxqt
	12) sway${reset}"
	read answr3
	[ "$answr3" == "1" ] && plasma
	[ "$answr3" == "2" ] && gnome
	[ "$answr3" == "3" ] && deepin
	[ "$answr3" == "4" ] && cutefish
	[ "$answr3" == "5" ] && budgie
	[ "$answr3" == "6" ] && cinnamon
	[ "$answr3" == "7" ] && mate
	[ "$answr3" == "8" ] && xfce
	[ "$answr3" == "9" ] && enlightenment
	[ "$answr3" == "10" ] && lxde
	[ "$answr3" == "11" ] && lxqt
	[ "$answr3" == "12" ] && sway
	bluetooth
}
function plasma {
	clear
	pacman -S plasma konsole dolphin kate spectacle plasma-wayland-session gwenview ark p7zip unrar unarchiver lzop lrzip okular filelight networkmanager flatpak rsibreak
	systemctl enable sddm
	systemctl enable NetworkManager.service
	clear
	echo -e "${red}${bold}should I disable kde wallet?
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
function gnome {
	clear
	pacman -S gnome ffmpegthumbnailer gst-libav gst-plugins-ugly networkmanager gnome-tweaks
	systemctl enable NetworkManager.service
	systemctl enable gdm
}
function deepin {
	clear
	pacman -S deepin networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lightdm
}
function cutefish {
	clear
	pacman -S cutefish sddm networkmanager
	systemctl enable NetworkManager.service
	systemctl enable sddm
}
function budgie {
	clear
	pacman -S lxdm-gtk3 budgie-desktop networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lxdm
}
function cinnamon {
	clear
	pacman -S cinnamon lxdm-gtk3 xfce4-terminal xed networkmanager xfce4-taskmanager gvfs tumbler thunar-volman thunar-archive-plugin thunar
	systemctl enable NetworkManager.service
	systemctl enable lxdm
	bluetooth_support=0
}
function mate {
	clear
	pacman -S mate mate-extra lxdm-gtk3 networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lxdm
}
function xfce {
	clear
	pacman -S xfce4 lxdm-gtk3 xfce4-xkb-plugin mousepad xfce4-pulseaudio-plugin pavucontrol pulseaudio xfce4-screenshooter xfce4-taskmanager networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lxdm
}
function enlightenment {
	clear
	pacman -S enlightenment lxdm-gtk3 terminology networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lxdm
}
function lxde {
	clear
	pacman -S lxde-gtk3 networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lxdm
}
function lxqt {
	clear
	pacman -S lxqt lxdm-gtk3 networkmanager
	systemctl enable NetworkManager.service
	systemctl enable lxdm
}
function sway {
	clear
	pacman -S sway pulseaudio pamixer
}
function bluetooth {
	clear
	echo -e "${red}${bold}should I enable bluetooth?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && (pacman -S bluez bluez-utils && systemctl enable bluetooth.service)
	[ "$bluetooth_support" == "0" ] && pacman -S blueberry
}
function additional_packages {
	clear
	echo -e "${red}${bold}should I install some additional packages?
	1) yes
	2) no${reset}"
	read pick
	[ "$pick" == "1" ] && install_additional_packages
}
function install_additional_packages {
	clear
	echo -e "${red}${bold}enter packages to install${reset}"
	read moar
	clear
	pacman -S $moar
}
function doas {
	clear
	pacman -S opendoas
	ls /etc | grep -w "doas.conf" && rm /etc/doas.conf
	echo "permit persist $name as root" >> /etc/doas.conf
}
function trim_enabler {
	systemctl enable fstrim.service
	systemctl enable fstrim.timer
}
clear
locale-gen
clear
echo -e "${red}${bold}set your hostname${reset}"
read host
echo $host >> /etc/hostname
clear
echo -e "${red}${bold}set your root password${reset}"
passwd
clear
echo -e "${red}${bold}should I add user?
1) yes
2) no${reset}"
read answr
[ "$answr" == "1" ] && user
clear
echo -e "${red}${bold}should I enable dhcpcd?
1) yes
2) no${reset}"
read dhcp
[ "$dhcp" == "1" ] && systemctl enable dhcpcd
clear
echo -e "${red}${bold}what should I install?
1) sudo
2) doas
3) nothing${reset}"
read sdo
[ "$sdo" == "1" ] && sudo_install
[ "$sdo" == "2" ] && doas
install_desktop_enviroment
clear
additional_packages
ls | grep -w "encrypt" && (rm /etc/mkinitcpio.conf && mv mkinitcpio.conf /etc/ && mkinitcpio -P)
find trim && trim_enabler
