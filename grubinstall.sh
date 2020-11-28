#!/bin/bash
function search {
	clear
	ls | cat >> files
	grep -i "2" files && grubB || grubU
}
function grubinstall {
	clear
	pacman -S grub
	clear
	lsblk
	echo "Set your drive(not partition) to install grub"
	read deviceforinstall
	system
}
function system {
	clear
	search
}
function grubB {
	clear
	grub-install --target=i386-pc $deviceforinstall
	clear
	echo "Do you have Windows installed on your PC?
	1) Yes
	2) No"
	read winer
	[ "$winer" == "1" ] && pacman -S  os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
function grubU {
	clear
	pacman -S efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	clear
	echo "Do you have Windows installed on your PC?
	1) Yes
	2) No"
	read win
	[ "$win" == "1" ] && pacman -S  os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
clear
grubinstall
clear
exit 0
