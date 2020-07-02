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
	4) xfce"
	read answr3
	[ "$answr3" == "1" ] && plasma
	[ "$answr3" == "2" ] && mate
	[ "$answr3" == "3" ] && gnome
	[ "$answr3" == "4" ] && xfce
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
function system {
	clear
	find 2 && grubB || grubU
}
function grubB {
	clear
	grub-install --target=i386-pc $deviceforinstall
	echo "Do you have Windows installed on your PC(yes/no)?"
	read winer
	[ "$winer" == "yes" ] && pacman -S  os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
function grubU {
	clear
	pacman -S efibootmgr
	grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
	clear
	echo "Do you have Windows installed on your PC(yes/no)?"
	read win
	[ "$win" == "yes" ] && pacman -S  os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
function gruby {
	clear
	echo "Should I install grub(yes/no)?"
	read nothing
	[ "$nothing" == "yes" ] && grubinstall
}
function grubinstall {
	clear
	pacman -S grub
	clear
	lsblk -f
	echo "Set your drive(not partition) to install grub"
	read deviceforinstall
	system
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
tzselect
clear
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
clear
gruby
clear
pack
exit 0
