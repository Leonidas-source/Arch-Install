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
	echo "Should I install DE?
	1) yes
	2) no"
	read answr2
	[ "$answr2" == "1" ] && wmy
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
	pacman -S plasma-meta konsole dolphin kate
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
	echo "Should I install some additional packages?
	1) Yes
	2) No"
	read pick
	[ "$pick" == "1" ] && installpack
}
function installpack {
	clear
	echo "Enter packages to install"
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
clear
fstab
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
echo "Should I add user?
1) Yes
2) No"
read answr
[ "$answr" == "1" ] && user
clear
echo "Should I enable dhcpcd?
1) Yes
2) No"
read dhcp
[ "$dhcp" == "1" ] && systemctl enable dhcpcd
clear
echo "Should I install sudo?
1) Yes
2) No"
read sdo
[ "$sdo" == "1" ] && heyyy
wm
clear
pack
exit 0
