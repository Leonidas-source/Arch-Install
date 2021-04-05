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
function search {
	clear
	ls | grep -w "2" && grubB || grubU
}
function grubinstall {
	clear
	pacman -S grub
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
	[ "$winer" == "1" ] && pacman -S os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
function grubU {
	clear
	pacman -S efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	clear
	echo -e "${red}${bold}Do you have Windows installed on your PC?
	1) Yes
	2) No${reset}"
	read win
	[ "$win" == "1" ] && pacman -S os-prober
	clear
	grub-mkconfig -o /boot/grub/grub.cfg
}
clear
grubinstall
clear
