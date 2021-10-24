#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
function search {
	clear
	ls | grep -w "2" && grubB || grubU
}
function grubinstall {
	clear
	yes|pacman -S grub
	clear
	lsblk
	echo -e "${red}${bold}Set your drive(not partition) to install grub${reset}"
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
	echo -e "${red}${bold}Do you have Windows installed on your PC?
	1) Yes
	2) No${reset}"
	read winer
	[ "$winer" == "1" ] && yes|pacman -S os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
function grubU {
	clear
	yes|pacman -S efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	clear
	echo -e "${red}${bold}Do you have Windows installed on your PC?
	1) Yes
	2) No${reset}"
	read win
	[ "$win" == "1" ] && yes|pacman -S os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
clear
grubinstall
clear
