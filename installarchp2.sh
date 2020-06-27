#!/bin/bash
function user {
	clear
	echo "Set name for your user"
	read name
	useradd -m $name
	clear
	echo "Set password for your user"
	passwd $name
	echo "Done"
}
function heyyy {
	clear
	yes|pacman -S sudo
	EDITOR=nano visudo
} 
function wm {
	clear
	echo "Should I install DE(yes/no?"
	read answr2
	[ "$answr2" == "yes" ] && wmy
}
function wmy {
	clear
	echo "Set your DE(plasma/mate/gnome/xfce)"
	read answr3
	[ "$answr3" == "plasma" ] && plasma
	[ "$answr3" == "mate" ] && mate
	[ "$answr3" == "gnome" ] && gnome
	[ "$answr3" == "xfce" ] && xfce
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
ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
nano /etc/locale.gen
clear
locale-gen
clear
echo "Set your hostname"
echo "To exit use CTRL+D"
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
exit

