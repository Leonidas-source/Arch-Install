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
function format_root {
	echo "Set filesystem for /
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat"
	read filesys
	[ "$filesys" == "1" ] && mkfs.ext4 $ESP3
	[ "$filesys" == "2" ] && mkfs.ext3 $ESP3
	[ "$filesys" == "3" ] && mkfs.xfs $ESP3
	[ "$filesys" == "4" ] && ohhmanifeelsosleepy
	[ "$filesys" == "5" ] && mkfs.ext2 $ESP3
	[ "$filesys" == "6" ] && mkfs.vfat $ESP3
	[ "$filesys" == "7" ] && mkfs.exfat $ESP3
}
function format_efi {
	echo "Set your filesystem for EFI partition
	1) FAT32
	2) EXFAT"
	read EXFAT
	[ "$EXFAT" == "1" ] && mkfs.vfat $part1
	[ "$EXFAT" == "2" ] && mkfs.exfat $part1
}
function formatforUEFI {
	clear
	lsblk
	echo "Set your EFI partition"
	read part1
	echo "should i format it?
	1) yes
	2) no"
	read answr5
	[ "$answr5" == "1" ] && format_efi
	clear
	lsblk
	echo "Set your / partition"
	read ESP3
	echo "should i format it?
	1) yes
	2) no"
	read answr4
	[ "$answr4" == "yes" ] && format_root
	clear
	mount $ESP3 /mnt
	mkdir /mnt/boot
	create_boot_entry
	mount $part1 /mnt/boot
}
function create_boot_entry {
	touch boot.mount
	echo "[Unit]" | cat >> boot.mount
	echo "Description=boot partition" | cat >> boot.mount
	echo " " | cat >> boot.mount
	echo "[Mount]" | cat >> boot.mount
	bootle=$(lsblk -f $part1 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "What=/dev/disk/by-uuid/$bootle" | cat >> boot.mount
	echo "Where=/boot" | cat >> boot.mount
	bootle2=$(lsblk -f $part1 -o FSTYPE | sed s/"FSTYPE"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "Type=$bootle2" | cat >> boot.mount
	echo " " | cat >> boot.mount
	echo "[Install]" | cat >> boot.mount
	echo "WantedBy=multi-user.target" | cat >> boot.mount
}
function ohhmanifeelsosleepy {
	clear
	mkfs.btrfs $ESP3
	mkdir test
	mount $ESP3 test
	btrfs subvolume create test/root
	btrfs subvolume set-default 256 test
	umount $ESP3
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
function format_root_BIOS {
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
}
function formatforBIOS {
	clear
	lsblk
	echo "Set you / partition"
	read root
	echo "should i format it?
	1) yes
	2) no"
	read answr6
	[ "$answr6" == "yes" ] && format_root_BIOS
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
	create_home_entry
	mount $homepart /mnt/home
}
function create_home_entry {
	touch home.mount
	echo "[Unit]" | cat >> home.mount
	echo "Description=home partition" | cat >> home.mount
	echo " " | cat >> home.mount
	echo "[Mount]" | cat >> home.mount
	oohmy=$(lsblk -f $homepart -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "What=/dev/disk/by-uuid/$oohmy" | cat >> home.mount
	echo "Where=/home" | cat >> home.mount
	oohmy2=$(lsblk -f $homepart -o FSTYPE | sed s/"FSTYPE"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "Type=$oohmy2" | cat >> home.mount
	echo " " | cat >> home.mount
	echo "[Install]" | cat >> home.mount
	echo "WantedBy=multi-user.target" | cat >> home.mount
}
function btrfserforhome {
	clear
	mkfs.btrfs $homepart
	mkdir fuckme
	mount $homepart fuckme
	btrfs subvolume create fuckme/home
	btrfs subvolume set-default 256 fuckme
	umount $homepart
	create_home_entry
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
	arch-chroot /mnt bootctl install
	systemdpart1
}
function systemdpart1 {
	cd /mnt/boot/loader/
	rm loader.conf
	touch loader.conf
	echo "default arch.conf" | cat >> loader.conf
	echo "timeout  5" | cat >> loader.conf
	echo "console-mode max" | cat >> loader.conf
	echo "editor   no" | cat >> loader.conf
	systemdpart2
}
function systemdpart2 {
	mkdir /mnt/boot/loader/entries
	cd /mnt/boot/loader/entries
	touch arch.conf
	cd $reserve_thing
	echo "title   Arch Linux" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LINUX" && echo "linux   /vmlinuz-linux" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "HARD" && echo "linux   /vmlinuz-linux-hardened" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LTS" && echo "linux   /vmlinuz-linux-lts" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "ZEN" && echo "linux   /vmlinuz-linux-zen" | cat >> /mnt/boot/loader/entries/arch.conf
	systemdpart3
}
function systemdpart3 {
	ls | grep -w "LINUX" && echo "initrd  /initramfs-linux.img" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "HARD" && echo "initrd  /initramfs-linux-hardened.img" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "LTS" && echo "initrd  /initramfs-linux-lts.img" | cat >> /mnt/boot/loader/entries/arch.conf
	ls | grep -w "ZEN" && echo "initrd  /initramfs-linux-zen.img" | cat >> /mnt/boot/loader/entries/arch.conf
	clear
	lsblk
	echo "enter root partition"
	read root_partition
	ESP4=$(lsblk -f $root_partition -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "options root="'"'UUID="$ESP4"'"' " rw " | cat >> /mnt/boot/loader/entries/arch.conf
}
function pewpew {
	arch-chroot /mnt sh grubinstall.sh
}
reserve_thing=$(pwd)
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
[ "$kernel" == "1" ] && pacstrap /mnt base linux linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && touch LINUX
[ "$kernel" == "2" ] && pacstrap /mnt base linux-hardened linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && touch HARD
[ "$kernel" == "3" ] && pacstrap /mnt base linux-lts linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && touch LTS
[ "$kernel" == "4" ] && pacstrap /mnt base linux-zen linux-firmware dhcpcd nano mc exfat-utils btrfs-progs curl && touch ZEN
clear
mv locale.conf /mnt/etc
mv userland.sh /mnt
mv grubinstall.sh /mnt
mv boot.mount /mnt
ls | grep -w "home.mount" && mv home.mount /mnt
arch-chroot /mnt sh userland.sh
clear
ls | grep 2 && mv 2 /mnt
ls /mnt | grep 2 && pewpew || booter
clear
rm /mnt/grubinstall.sh
rm /mnt/userland.sh
ln -sf /usr/share/zoneinfo/"$(curl --fail https://ipapi.co/timezone)" /mnt/etc/localtime
