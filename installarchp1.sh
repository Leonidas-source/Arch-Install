#!/bin/bash
function erasedisk {
	clear
	lsblk -f
	echo "Set your disk"
	read disk
	clear
	echo "Set mode of erasing
	1) Auto
	2) Manual"
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
	echo "Select source
	1) zero
	2) urandom"
	read zeroing
	[ "$zeroing" == "1" ] && dd if=/dev/zero of=$disk bs=$block count=$input status=progress
	[ "$zeroing" == "2" ] && dd if=/dev/urandom of=$disk bs=$block count=$input status=progress
}
function formatforUEFI {
	clear
	lsblk -f
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
	lsblk -f
	echo "Set your / partition"
	read part2
	clear
	echo "Set your filesystem(ext3,ext4,xfs,btrfs...) for /"
	read filesys
	clear
	mkfs.$filesys $part2
	clear
	mount $part2 /mnt
	mkdir /mnt/boot
	mount $part1 /mnt/boot
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
	1) BIOS
	2) UEFI"
	read some
	[ "$some" == "1" ] && formatforBIOS
	[ "$some" == "2" ] && formatforUEFI
}
function formatforBIOS {
	clear
	lsblk -f
	echo "Set you / partition"
	read root
	clear
	echo "Set filesystem(ext3,ext4,xfs,btrfs...) for /"
	read filese
	clear
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
	echo "Should I erase disk with future home partition(yes/no)?"
	read may
	[ "$may" == "yes" ] && rmhome
	clear
	echo "Should I create home partition(yes/no)?"
	read kek
	[ "$kek" == "yes" ] && hommy
	clear
	lsblk -f
	echo "Set your home partition"
	read homepart
	clear
	echo "Should I format it(yes/no)?"
	read somehome
	[ "$somehome" == "yes" ] && formathome
	mkdir /mnt/home
	mount $homepart /mnt/home
}
function rmhome {
	clear
	lsblk -f
	echo "Select your disk"
	read killdisk
	clear
	echo "Set mode of erasing
	1) Auto
	2) Manual"
	read killhome
	[ "$killhome" == "1" ] && lolman
	[ "$killhome" == "2" ] && nonman
}
function lolman {
	clear
	dd if=/dev/zero of=$killdisk status=progress
}
function nonman {
	clear
	echo "Set your block size"
	read blocky
	clear
	echo "Set your input(count)"
	read inputy
	clear
	echo "Select source
	1) zero
	2) urandom"
	read zeroingy
	[ "$zeroingy" == "1" ] && dd if=/dev/zero of=$killdisk bs=$blocky count=$inputy status=progress
	[ "$zeroingy" == "2" ] && dd if=/dev/urandom of=$killdisk bs=$blocky count=$inputy status=progress
}
function hommy {
	clear
	lsblk -f
	echo "Set your drive with future home partition"
	read future
	clear
	cfdisk $future
}
function formathome {
	clear
	echo "Set your filesystem(ext3,ext4,xfs,btrfs...)"
	read idea
	mkfs.$idea $homepart
}
function booter {
	clear
	echo "Set your bootloader
	1) grub
	2) EFISTUB"
	read efilol
	[ "$efilol" == "1" ] && pewpew
	[ "$efilol" == "2" ] && STUB
}
function STUB {
	clear
	lsblk -f
	echo "Set your drive(not partition) with ESP"
	read ESP
	clear
	lsblk -f $ESP
	echo "Set number of that(ESP) partition (1,2,3,4)"
	read ESP2
	clear
	lsblk -f
	echo "Set / partition"
	read ESP3
	clear
	lsblk -f $ESP3
	echo "Set UUID"
	read ESP4
	clear
	efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'root=UUID'$ESP4' rw initrd=\initramfs-linux.img'
}
function gruby {
	clear
	echo "Should I install bootloader(yes/no)?"
	read nothing
	[ "$nothing" == "yes" ] && booter
}
function pewpew {
	arch-chroot /mnt sh grubinstall.sh
}
clear
echo "Should I Erase your disk(yes/no)?"
read answr
[ "$answr" == "yes" ] && erasedisk
clear
lsblk -f
echo "Set disk to install Arch Linux"
read membrane
clear
cfdisk $membrane
clear
echo "Should I format all partitions(yes/no)?"
read answr2
[ "$answr2" == "yes" ] && system
clear
echo "Should I install Swap partiotion(yes/no)?"
read answr3
[ "$answr3" == "yes" ] && swap
clear
home
clear
rm /etc/pacman.d/mirrorlist
mv mirrorlist /etc/pacman.d/
nano /etc/pacman.d/mirrorlist
clear
pacstrap /mnt base linux linux-firmware dhcpcd nano exfat-utils && genfstab -U /mnt >> /mnt/etc/fstab
clear
mv locale.conf /mnt/etc
mv installarchp2.sh /mnt
mv grubinstall.sh /mnt
arch-chroot /mnt sh installarchp2.sh
clear
gruby
clear
