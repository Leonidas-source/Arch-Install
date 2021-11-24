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
function heyyy {
	clear
	pacman -S sudo
	EDITOR=nano visudo
}
function wm {
	clear
	echo -e "${red}${bold}should I install DE?
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
	video_detection
}
function plasma {
	clear
	pacman -S plasma-meta konsole dolphin kate plasma-wayland-session gwenview ark p7zip unrar unarchiver lzop lrzip okular filelight
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
	pacman -S gnome ffmpegthumbnailer gst-libav gst-plugins-ugly
	systemctl enable gdm
}
function deepin {
	clear
	pacman -S deepin
	systemctl enable lightdm
}
function cutefish {
	clear
	pacman -S cutefish sddm
	systemctl enable sddm
}
function budgie {
	clear
	pacman -S lxdm-gtk3 budgie-desktop
	systemctl enable lxdm
}
function cinnamon {
	clear
	pacman -S cinnamon lxdm-gtk3 xfce4-terminal xed
	systemctl enable lxdm
}
function mate {
	clear
	pacman -S mate mate-extra lxdm-gtk3
	systemctl enable lxdm
}
function xfce {
	clear
	pacman -S xfce4 lxdm-gtk3 xfce4-xkb-plugin mousepad xfce4-pulseaudio-plugin pavucontrol pulseaudio xfce4-screenshooter xfce4-taskmanager
	systemctl enable lxdm
}
function enlightenment {
	clear
	pacman -S enlightenment lxdm-gtk3 terminology
	systemctl enable lxdm
}
function lxde {
	clear
	pacman -S lxde-gtk3
	systemctl enable lxdm
}
function lxqt {
	clear
	pacman -S lxqt lxdm-gtk3
	systemctl enable lxdm
}
function sway {
	clear
	pacman -S sway pulseaudio pamixer
}
function pack {
	clear
	echo -e "${red}${bold}should I install some additional packages?
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
function video_detection {
	clear
	lspci | grep Radeon && amdgpu_drivers
}
function amdgpu_drivers {
	pacman -S xf86-video-amdgpu vulkan-radeon
}
clear
fstab
rm /etc/locale.gen
mv locale.gen /etc/
locale-gen
clear
echo -e "${red}${bold}set your hostname${reset}"
echo -e "${red}${bold}to exit press CTRL+D twice${reset}"
cat > /etc/hostname
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
[ "$sdo" == "1" ] && heyyy
[ "$sdo" == "2" ] && doas
wm
clear
pack
ls | grep -w "encrypt" && (rm /etc/mkinitcpio.conf && mv mkinitcpio.conf /etc/ && mkinitcpio -P)
