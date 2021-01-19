#!/bin/bash
function check_BIOS {
	ls | grep 2 && formatforBIOS || formatforUEFI
}
function once_more {
	clear
	echo "Should I erase your disk once more?
	1) Yes
	2) No"
	read addit
	[ "$addit" == "1" ] && erasedisk
}
function erasedisk {
	clear
	lsblk
	echo "Set your disk"
	read disk
	clear
	echo "Set mode of erasing
	1) Auto
	2) Manual"
	read method
	[ "$method" == "1" ] && full
	[ "$method" == "2" ] && partial
	once_more
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
	echo "Select source
	1) zero
	2) urandom"
	read zeroing
	[ "$zeroing" == "1" ] && dd if=/dev/zero of=$disk bs=$block count=$input status=progress
	[ "$zeroing" == "2" ] && dd if=/dev/urandom of=$disk bs=$block count=$input status=progress iflag=fullblock
}
function formatforUEFI {
	clear
	lsblk
	echo "Set your EFI partition"
	read part1
	clear
	echo "Set your filesystem for EFI partition
	1) FAT32
	2) EXFAT"
	read EXFAT
	[ "$EXFAT" == "1" ] && mkfs.vfat $part1
	[ "$EXFAT" == "2" ] && mkfs.exfat $part1
	clear
	lsblk
	echo "Set your / partition"
	read part2
	clear
	echo "Set filesystem for /
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat"
	read filesys
	[ "$filesys" == "1" ] && mkfs.ext4 $part2
	[ "$filesys" == "2" ] && mkfs.ext3 $part2
	[ "$filesys" == "3" ] && mkfs.xfs $part2
	[ "$filesys" == "4" ] && ohhmanifeelsosleepy
	[ "$filesys" == "5" ] && mkfs.ext2 $part2
	[ "$filesys" == "6" ] && mkfs.vfat $part2
	[ "$filesys" == "7" ] && mkfs.exfat $part2
	clear
	mount $part2 /mnt
	mkdir /mnt/boot
	mount $part1 /mnt/boot
}
function ohhmanifeelsosleepy {
	clear
	mkfs.btrfs $part2
	mkdir test
	mount $part2 test
	btrfs subvolume create test/root
	btrfs subvolume set-default 256 test
	umount $part2
}
function swap {
	clear
	lsblk
	echo "Set your Swap partition"
	read part3
	mkswap $part3
	swapon $part3
}
function system {
	clear
	echo "Set your system
	1) BIOS
	2) UEFI"
	read some
	[ "$some" == "1" ] && touch 2
}
function btrfser {
	clear
	mkfs.btrfs $root
	mkdir test
	mount $root test
	btrfs subvolume create test/root
	btrfs subvolume set-default 256 test
	umount $root
}
function formatforBIOS {
	clear
	lsblk
	echo "Set you / partition"
	read root
	clear
	echo "Set filesystem for /
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat"
	read filese
	[ "$filese" == "1" ] && mkfs.ext4 $root
	[ "$filese" == "2" ] && mkfs.ext3 $root
	[ "$filese" == "3" ] && mkfs.xfs $root
	[ "$filese" == "4" ] && btrfser
	[ "$filese" == "5" ] && mkfs.ext2 $root
	[ "$filese" == "6" ] && mkfs.vfat $root
	[ "$filese" == "7" ] && mkfs.exfat $root
	clear
	mount $root /mnt
}
function home {
	clear
	echo "Should I set home partition?
	1) Yes
	2) No"
	read home
	[ "$home" == "1" ] && installhome
}
function installhome {
	clear
	echo "Should I erase disk with future home partition?
	1) Yes
	2) No"
	read may
	[ "$may" == "1" ] && rmhome
	clear
	lsblk
	echo "Set your home partition"
	read homepart
	clear
	echo "Should I format it?
	1) Yes
	2) No"
	read somehome
	[ "$somehome" == "1" ] && formathome
	mkdir /mnt/home
	mount $homepart /mnt/home
}
function btrfserforhome {
	clear
	mkfs.btrfs $homepart
	mkdir fuckme
	mount $homepart fuckme
	btrfs subvolume create fuckme/home
	btrfs subvolume set-default 256 fuckme
	umount $homepart
}
function formathome {
	clear
	echo "Set your filesystem
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat"
	read idea
	[ "$idea" == "1" ] && mkfs.ext4 $homepart
	[ "$idea" == "2" ] && mkfs.ext3 $homepart
	[ "$idea" == "3" ] && mkfs.xfs $homepart
	[ "$idea" == "4" ] && btrfserforhome
	[ "$idea" == "5" ] && mkfs.ext2 $homepart
	[ "$idea" == "6" ] && mkfs.vfat $homepart
	[ "$idea" == "7" ] && mkfs.exfat $homepart
}
function booter {
	clear
	echo "Set your bootloader
	1) grub
	2) EFISTUB
	3) systemd-boot
	4) none"
	read efilol
	[ "$efilol" == "1" ] && pewpew
	[ "$efilol" == "2" ] && sh stub.sh
	[ "$efilol" == "3" ] && systemd
}
function systemd {
	cp LINUX /mnt
	cp HARD /mnt
	cp LTS /mnt
	cp ZEN /mnt
	arch-chroot /mnt sh systemd-boot.sh
}
function pewpew {
	arch-chroot /mnt sh grubinstall.sh
}
clear
echo "Should I Erase your disk?
1) Yes
2) No"
read answr
[ "$answr" == "1" ] && erasedisk
clear
lsblk
echo "Set disk to install Arch Linux"
read membrane
clear
cfdisk $membrane
clear
system
echo "Should I format all partitions?
1) Yes
2) No"
read answr2
[ "$answr2" == "1" ] && check_BIOS
clear
echo "Should I install Swap partiotion?
1) Yes
2) No"
read answr3
[ "$answr3" == "1" ] && swap
clear
home
clear
rm /etc/pacman.d/mirrorlist
mv mirrorlist /etc/pacman.d/
nano /etc/pacman.d/mirrorlist
clear
echo "set your kernel
1)Stable(default)
2)Hardened(more secure)
3)LTS(long time support)
4)Zen Kernel(Zen Patched Kernel)"
read kernel
[ "$kernel" == "1" ] && pacstrap /mnt base linux linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && genfstab -U /mnt >> /mnt/etc/fstab && touch LINUX
[ "$kernel" == "2" ] && pacstrap /mnt base linux-hardened linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && genfstab -U /mnt >> /mnt/etc/fstab && touch HARD
[ "$kernel" == "3" ] && pacstrap /mnt base linux-lts linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && genfstab -U /mnt >> /mnt/etc/fstab && touch LTS
[ "$kernel" == "4" ] && pacstrap /mnt base linux-zen linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && genfstab -U /mnt >> /mnt/etc/fstab && touch ZEN
clear
mv locale.conf /mnt/etc
mv userland.sh /mnt
mv grubinstall.sh /mnt
arch-chroot /mnt sh userland.sh
clear
ls | grep 2 && mv 2 /mnt
ls /mnt | grep 2 && pewpew || booter
clear
rm /mnt/grubinstall.sh
rm /mnt/userland.sh
yes|pacman -Sy curl
ln -sf /usr/share/zoneinfo/"$(curl --fail https://ipapi.co/timezone)" /mnt/etc/localtime
clear
ls /mnt | grep 2 && rm /mnt/2
ls /mnt | grep LINUX && rm /mnt/LINUX
ls /mnt | grep HARD && rm /mnt/HARD
ls /mnt | grep LTS && rm /mnt/LTS
ls /mnt | grep ZEN && rm /mnt/ZEN
