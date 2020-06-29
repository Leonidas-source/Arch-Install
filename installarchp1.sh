#!/bin/bash
function erasedisk {
	clear
	lsblk -f
	echo "Set your disk"
	read disk
	dd if=/dev/zero of=$disk status=progress
}
function format {
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
	mkfs.exfat $part1
}
function swap {
	clear
	lsblk -f
	echo "Set your Swap partition"
	read part3
	mkswap $part3
	swapon $part3
}
echo "Should I Erase your disk(yes/no)?"
read answr
[ "$answr" == "yes" ] && erasedisk
clear
cfdisk $disk
clear
echo "Should I format all partitions(yes/no)?"
read answr2
[ "$answr2" == "yes" ] && format
clear
echo "Should I install Swap partiotion(yes/no)?"
read answr3
[ "$answr3" == "yes" ] && swap
clear
mount $part2 /mnt
clear
mkdir /mnt/boot
mount $part1 /mnt/boot
clear
nano /etc/pacman.d/mirrorlist
clear
pacstrap /mnt base linux linux-firmware dhcpcd nano exfat-utils && genfstab -U /mnt >> /mnt/etc/fstab
clear
mv locale.conf /mnt/etc
mv installarchp2.sh /mnt
arch-chroot /mnt
