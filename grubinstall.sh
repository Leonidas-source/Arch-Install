#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
function search {
	ls | grep -w "2" && grubB || grubU
}
function grubinstall {
	clear
	pacman -S grub
	deviceforinstall=$(cat file_for_grub)
	search
}
function grubB {
	clear
	grub-install --target=i386-pc $deviceforinstall
	clear
	echo -e "${red}${bold}Do you have Windows installed on your PC?
	1) yes
	2) no${reset}"
	read winer
	[ "$winer" == "1" ] && pacman -S os-prober
	grub-mkconfig -o /boot/grub/grub.cfg
}
function grubU {
	clear
	pacman -S efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
	clear
	echo -e "${red}${bold}Do you have Windows installed on your PC?
	1) yes
	2) no${reset}"
	read win
	[ "$win" == "1" ] && pacman -S os-prober
	grub-mkconfig -o /boot/grub/grub.cfg
}
grubinstall
