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
function systemd {
	arch-chroot /mnt bootctl install
	systemdpart1
}
function systemdpart1 {
	cd /mnt/boot/loader/
	rm loader.conf
	touch loader.conf
	echo "default arch.conf" | cat >> loader.conf
	echo "timeout 0" | cat >> loader.conf
	echo "console-mode max" | cat >> loader.conf
	echo "editor no" | cat >> loader.conf
	systemdpart2
}
function systemdpart2 {
	mkdir /mnt/boot/loader/entries
	cd /mnt/boot/loader/entries
	touch arch.conf
	cd $reserve_thing
	echo "title Arch Linux" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LINUX" && echo "linux /vmlinuz-linux" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "HARD" && echo "linux /vmlinuz-linux-hardened" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LTS" && echo "linux /vmlinuz-linux-lts" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "ZEN" && echo "linux /vmlinuz-linux-zen" | cat >> /mnt/boot/loader/entries/arch.conf
	systemdpart3
}
function systemdpart3 {
	ls | grep -w "LINUX" && echo "initrd /initramfs-linux.img" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "HARD" && echo "initrd /initramfs-linux-hardened.img" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LTS" && echo "initrd /initramfs-linux-lts.img" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "ZEN" && echo "initrd /initramfs-linux-zen.img" | cat >> /mnt/boot/loader/entries/arch.conf
	clear
	lsblk
	echo -e "${red}${bold}Set your root partition(/dev/sda,/dev/sdb...)"
	read root
	arg=$(lsblk -f /dev/mapper/root -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	real=$(lsblk -f $root -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	ls | grep -w "zlib_root" && var=$(echo "compress-force=zlib")
	ls | grep -w "lzo_root" && var=$(echo "compress-force=lzo")
	ls | grep -w "zstd_root" && var=$(echo "compress-force=zstd")
	ls | grep -w "encrypt" && echo "options rd.luks.name="$real"=root_partition root="'"'UUID="$arg"'"' " rw $var" | cat >> /mnt/boot/loader/entries/arch.conf && touch already
	ls | grep -w "already" || echo "options root="'"'UUID="$real"'"' " rw $var" | cat >> /mnt/boot/loader/entries/arch.conf
}
systemd
