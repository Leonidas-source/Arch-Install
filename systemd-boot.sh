#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
function systemd {
	arch-chroot /mnt bootctl install
	systemdpart1
}
function systemdpart1 {
	cd /mnt/boot/loader/
	rm loader.conf
	touch loader.conf
	echo "default arch.conf" >> loader.conf
	echo "timeout 0" >> loader.conf
	echo "console-mode max" >> loader.conf
	echo "editor no" >> loader.conf
	systemdpart2
}
function systemdpart2 {
	mkdir /mnt/boot/loader/entries
	cd /mnt/boot/loader/entries
	touch arch.conf
	cd $reserve_thing
	echo "title Arch Linux" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LINUX" && echo "linux /vmlinuz-linux" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "HARD" && echo "linux /vmlinuz-linux-hardened" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LTS" && echo "linux /vmlinuz-linux-lts" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "ZEN" && echo "linux /vmlinuz-linux-zen" >> /mnt/boot/loader/entries/arch.conf
	systemdpart3
}
function systemdpart3 {
	ls | grep -w "LINUX" && echo "initrd /initramfs-linux.img" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "HARD" && echo "initrd /initramfs-linux-hardened.img" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LTS" && echo "initrd /initramfs-linux-lts.img" >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "ZEN" && echo "initrd /initramfs-linux-zen.img" >> /mnt/boot/loader/entries/arch.conf
	clear
	arg2=$(cat root_partition)
	ls | grep -w "encrypt" && arg3=$(lsblk -fd $arg2 -o UUID | sed "1d")
	ls | grep -w "encrypt" || arg3=$(lsblk -f $arg2 -o UUID | sed "1d")
	arg4=$(lsblk -fd /dev/mapper/root -o UUID | sed "1d")
	ls | grep -w "encrypt" && echo "options rd.luks.uuid=$arg3 root=\"UUID=$arg4\" rw " >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "encrypt" || echo "options root=\"UUID=$arg3\" rw " >> /mnt/boot/loader/entries/arch.conf
}
reserve_thing=$(pwd)
clear
systemd
