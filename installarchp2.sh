#!/bin/bash
function user {
	clear
	echo "Set name for your user"
	read name
	useradd -m $name
	clear
	echo "Set password for your user"
	passwd $name
}
function heyyy {
	clear
	pacman -S sudo
	EDITOR=nano visudo
}
function wm {
	clear
	echo "Should I install DE(yes/no)?"
	read answr2
	[ "$answr2" == "yes" ] && wmy
}
function wmy {
	clear
	echo "Set your DE
	1) plasma
	2) mate
	3) gnome
	4) xfce
	5) deepin
	6) cinnamon"
	read answr3
	[ "$answr3" == "1" ] && plasma
	[ "$answr3" == "2" ] && mate
	[ "$answr3" == "3" ] && gnome
	[ "$answr3" == "4" ] && xfce
	[ "$answr3" == "5" ] && deepin
	[ "$answr3" == "6" ] && cinnamon
}
function cinnamon {
	clear
	pacman -S cinnamon gdm
	systemctl enable gdm
}
function deepin {
	clear
	pacman -S deepin gdm
	systemctl enable gdm
}
function plasma {
	clear
	pacman -S plasma-meta
	systemctl enable sddm
}
function mate {
	clear
	pacman -S mate mate-extra lxdm
	systemctl enable lxdm
}
function gnome {
	clear
	pacman -S gnome
	systemctl enable gdm
}
function xfce {
	clear
	pacman -S xfce4 lxdm
	systemctl enable lxdm
}
function pack {
	clear
	echo "Should I install some additional packages(yes/no)?"
	read pick
	[ "$pick" == "yes" ] && installpack
}
function installpack {
	clear
	echo "Enter packages to install"
	read moar
	clear
	pacman -S $moar
}
clear
timedatectl set-ntp true
clear
nano /etc/locale.gen
clear
locale-gen
clear
echo "Set your hostname"
echo "To exit press CTRL+D twice"
cat > /etc/hostname
clear
echo "Set your root password"
passwd
clear
echo "Should I add user(yes/no)?"
read answr
[ "$answr" == "yes" ] && user
clear
echo "Should I enable dhcpcd(yes/no)?"
read dhcp
[ "$dhcp" == "yes" ] && systemctl enable dhcpcd
clear
echo "Should I install sudo(yes/no)?"
read sdo
[ "$sdo" == "yes" ] && heyyy
wm
clear
gruby
clear
pack
exit 0
