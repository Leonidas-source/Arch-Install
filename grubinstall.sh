#!/bin/bash
function grubinstall {
	clear
	pacman -S grub
	clear
	lsblk -f
	echo "Set your drive(not partition) to install grub"
	read deviceforinstall
	system
}
function system {
	clear
	find 2 && grubB || grubU
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
