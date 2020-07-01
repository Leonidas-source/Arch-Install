#!/bin/bash
function erasedisk {
	clear
	lsblk -f
	echo "Set your disk"
	read disk
	clear
	echo "Set method of erasing
	1)Full
	2)Partial"
	read method
	[ "$method" == "1" ] && full
	[ "$method" == "2" ] && partial
}
function full {
	clear
	dd if=/dev/zero of=$disk status=progress
}
function partial {
	clear
	echo "Set your block size"
	read block
	clear
	echo "Set your input(count)"
	read input
	clear
	dd if=/dev/zero of=$disk bs=$block count=$input
}
function formatforUEFI {
	clear
	lsblk -f
	echo "Set your EFI partition"
	read part1
	clear
	lsblk -f
	echo "Set your root partition"
	read part2
	echo "Set your filesystem(ext3,ext4,xfs,btrfs...)"
	read filesys
	mkfs.$filesys $part2
	clear
	mkfs.exfat $part1
	clear
	mkdir /mnt/boot
	mount $part1 /mnt/boot
	clear
	mount $part2 /mnt
}
function swap {
	clear
	lsblk -f
	echo "Set your Swap partition"
	read part3
	mkswap $part3
	swapon $part3
}
function system {
	clear
	echo "Set your system
	1)BIOS
	2)UEFI"
	read some
	[ "$some" == "1" ] && formatforBIOS
	[ "$some" == "2" ] && formatforUEFI
}
function formatforBIOS {
	clear
	lsblk -f
	echo "Set you root partition"
	read root
	clear
	echo "Set your filesystem(ext3,ext4,xfs,btrfs...)"
	read filese
	mkfs.$filese $root
	clear
	mount $root /mnt
	cat installarchp1.sh >> /mnt/2
}
function home {
	clear
	echo "Should I install home partition(yes/no)?"
	read home
	[ "$home" == "yes" ] && installhome
}
function installhome {
	clear
	lsblk -f
	echo "Set your home partition"
	read homepart
	clear
	echo "Should I format it?"
	read somehome
	["$somehome" == "yes"] && formathome
	mkdir /mnt/home
	mount $homepart /mnt/home
}
function formathome {
	clear
	echo "Set your filesystem(ext3,ext4,xfs,btrfs...)"
	read idea
	mkfs.$idea $homepart
}
clear
echo "Should I Erase your disk(yes/no)?"
read answr
[ "$answr" == "yes" ] && erasedisk
clear
cfdisk $disk
clear
echo "Should I format all partitions(yes/no)?"
read answr2
[ "$answr2" == "yes" ] && system
clear
echo "Should I install Swap partiotion(yes/no)?"
read answr3
[ "$answr3" == "yes" ] && swap
clear
nano /etc/pacman.d/mirrorlist
clear
pacstrap /mnt base linux linux-firmware dhcpcd nano exfat-utils && genfstab -U /mnt >> /mnt/etc/fstab
clear
mv locale.conf /mnt/etc
mv installarchp2.sh /mnt
arch-chroot /mnt sh installarchp2.sh
