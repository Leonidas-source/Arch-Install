#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"

### BIOS_INSTALL BEGIN
function auto_partitioning_BIOS {
	parted $membrane mklabel msdos -s
	parted $membrane mkpart primary linux-swap 1MiB 8217MiB
	parted $membrane mkpart primary ext2 8217MiB 100%
	parted $membrane set 2 boot on
	mkswap $membrane'1'
	swapon $membrane'1'
	mkfs.ext4 $membrane'2'
	mount $membrane'2' /mnt
	touch auto
}
function formatforBIOS {
	clear
	echo -e "${red}${bold}set your / partition${reset}"
	lsblk
	read root
	clear
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read answr6
	[ "$answr6" == "1" ] && format_root_BIOS
	mount $root /mnt
}
function format_root_BIOS {
	clear
	echo -e "${red}${bold}set filesystem for /
	1) ext4
	2) xfs
	3) btrfs${reset}"
	read filese
	[ "$filese" == "1" ] && mkfs.ext4 $root
	[ "$filese" == "2" ] && mkfs.xfs $root
	[ "$filese" == "3" ] && btrfser
}
function btrfser {
	mkfs.btrfs $root
	mkdir test
	mount $root test
	btrfs subvolume create test/root
	btrfs subvolume set-default 256 test
	umount $root
}

### BIOS_INSTALL END
function disk_to_install {
	clear
	echo -e "${red}${bold}set disk to install Arch Linux${reset}"
	lsblk
	read membrane
	echo $membrane >> file_for_grub
	clear
	echo -e "${red}${bold}how to partition your disk?
	1) auto partitioning
	2) manual partitioning${reset}"
	read answr
	[ "$answr" == "1" ] && set_auto_mode
	[ "$answr" == "2" ] && cfdisk $membrane
}
function set_auto_mode {
	find 2 && auto_partitioning_BIOS
	find 2 || auto_partitioning_UEFI
}

### UEFI_INSTALL BEGIN
function auto_partitioning_UEFI {
	parted $membrane mklabel gpt -s
	parted $membrane mkpart boot fat32 1MiB 1025MiB
	parted $membrane set 1 esp on
	parted $membrane mkpart swap linux-swap 1025MiB 9225MiB
	parted $membrane mkpart root ext2 9225MiB 100%
	part1=$membrane'1'
	ESP3=$membrane'3'
	mkfs.vfat $part1
	mkfs.ext4 $ESP3
	echo $ESP3 >> root_partition
	mount $ESP3 /mnt
	mkdir /mnt/boot
	mount $part1 /mnt/boot
	mkswap $membrane'2'
	swapon $membrane'2'
	touch auto
}
function format_root {
	ls | grep -w "encrypt" && ESP3=/dev/mapper/root
	clear
	echo -e "${red}${bold}set filesystem for /
	1) ext4
	2) xfs
	3) btrfs${reset}"
	read filesys
	[ "$filesys" == "1" ] && mkfs.ext4 $ESP3
	[ "$filesys" == "2" ] && mkfs.xfs $ESP3
	[ "$filesys" == "3" ] && ohhmanifeelsosleepy
}
function ohhmanifeelsosleepy {
	mkfs.btrfs $ESP3
	mkdir test
	mount $ESP3 test
	btrfs subvolume create test/root
	btrfs subvolume set-default 256 test
	umount $ESP3
}
function formatforUEFI {
	clear
	echo -e "${red}${bold}set your /boot partition${reset}"
	lsblk
	read part1
	clear
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read answr5
	[ "$answr5" == "1" ] && format_efi
	clear
	echo -e "${red}${bold}set your / partition${reset}"
	lsblk
	read -e ESP3
	echo $ESP3 >> root_partition
	encryption
	clear
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read answr4
	[ "$answr4" == "1" ] && format_root
	mount $ESP3 /mnt
	mkdir /mnt/boot
	mount $part1 /mnt/boot
}
function format_efi {
	clear
	echo -e "${red}${bold}set filesystem for /boot partition
	1) fat32
	2) exfat${reset}"
	read EXFAT
	[ "$EXFAT" == "1" ] && mkfs.vfat $part1
	[ "$EXFAT" == "2" ] && mkfs.exfat $part1 && touch nobootloader
}
### UEFI_INSTALL END

### Encryption BEGIN
function home_encryption {
	clear
	echo -e "${red}${bold}set /home partition${reset}"
	lsblk
	read home_encrypted
	ls | grep -w "encrypt" && easy_setup
	ls | grep -w "encrypt" || hard_setup
	touch encrypt_for_home
}
function home_set {
	touch homm
	clear
	echo -e "${red}${bold}should I encrypt /home?
	1) yes
	2) no${reset}"
	read home
	[ "$home" == "1" ] && home_encryption
	ls | grep -w "encrypt_for_home" && formathome
	ls | grep -w "encrypt_for_home" || installhome
}
function easy_setup {
	dd if=/dev/urandom of=home_key bs=1M count=1
	cryptsetup luksFormat $home_encrypted home_key
	cryptsetup open $home_encrypted secure_home --key-file home_key
	encrypted_home=easy
}
function hard_setup {
	cryptsetup luksFormat $home_encrypted
	cryptsetup open $home_encrypted secure_home
}
function check_for_home_encryption {
	ls | grep -w "encrypt_for_home" && securetab
}
function securetab {
	rm /mnt/etc/crypttab
	touch /mnt/etc/crypttab
	Calc=$(lsblk -fd $home_encrypted -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	[ "$encrypted_home" == "easy" ] && echo "secure_home UUID=$Calc /home_key" >> /mnt/etc/crypttab
	[ "$encrypted_home" == "easy" ] || echo "secure_home UUID=$Calc none timeout=180" >> /mnt/etc/crypttab
}
function encryption {
	clear
	echo -e "${red}${bold}should I encrypt / partition?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && root_encryption
}
function root_encryption {
	cryptsetup luksFormat $ESP3
	cryptsetup open $ESP3 root
	touch encrypt
}
### Encryption END

### Home BEGIN
function home {
	clear
	echo -e "${red}${bold}should I set /home partition?
	1) yes
	2) no${reset}"
	read home
	[ "$home" == "1" ] && home_set
}
function installhome {
	mkdir /mnt/home
	clear
	echo -e "${red}${bold}set your /home partition${reset}"
	lsblk
	read -e homepart
	clear
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read somehome
	[ "$somehome" == "1" ] && formathome
}
function formathome {
	ls | grep -w "encrypt_for_home" && homepart=/dev/mapper/secure_home
	clear
	echo -e "${red}${bold}set your filesystem for /home
	1) ext4
	2) ext3
	3) ext2
	4) xfs
	5) btrfs
	6) fat32
	7) exfat${reset}"
	read idea
	[ "$idea" == "1" ] && mkfs.ext4 $homepart
	[ "$idea" == "2" ] && mkfs.ext3 $homepart
	[ "$idea" == "3" ] && mkfs.ext2 $homepart
	[ "$idea" == "4" ] && mkfs.xfs $homepart
	[ "$idea" == "5" ] && btrfserforhome
	[ "$idea" == "6" ] && mkfs.vfat $homepart
	[ "$idea" == "7" ] && mkfs.exfat $homepart
	mount $homepart /mnt/home
}
function btrfserforhome {
	mkfs.btrfs $homepart
	mkdir btrfs-folder
	mount $homepart btrfs-folder
	btrfs subvolume create btrfs-folder/home
	btrfs subvolume set-default 256 btrfs-folder
	umount $homepart
	touch create_home_entry_file
}
### Home END

### FSTAB BEGIN
function create_home_entry {
	oohmy=$(lsblk -fd $homepart -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	oohmy2=$(lsblk -fd $homepart -o FSTYPE | sed s/"FSTYPE"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "UUID=$oohmy /home $oohmy2 defaults 0 0" >> /mnt/etc/fstab
}
function create_boot_entry {
	bootle=$(lsblk -f $part1 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	bootle2=$(lsblk -f $part1 -o FSTYPE | sed s/"FSTYPE"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "UUID=$bootle /boot $bootle2 defaults 0 2" >> /mnt/etc/fstab
}
function create_fstab_file {
	efibootmgr && create_boot_entry
	find homm && create_home_entry
}
### FSTAB END

### Bootloader BEGIN
function booter {
	find nobootloader || search
	find nobootloader && bash stub.sh
}
function search {
	ls | grep -w "encrypt" && menu_for_encrypted || menu_for_non_encrypted
}
function menu_for_encrypted {
	clear
	echo -e "${red}${bold}set your bootloader
	1) EFISTUB
	2) systemd-boot
	3) none${reset}"
	read efilol
	[ "$efilol" == "1" ] && bash stub.sh
	[ "$efilol" == "2" ] && bash systemd-boot.sh
}
function menu_for_non_encrypted {
	clear
	echo -e "${red}${bold}set your bootloader
	1) grub
	2) EFISTUB
	3) systemd-boot
	4) none${reset}"
	read efilol
	[ "$efilol" == "1" ] && arch-chroot /mnt bash grubinstall.sh
	[ "$efilol" == "2" ] && bash stub.sh
	[ "$efilol" == "3" ] && bash systemd-boot.sh
}
function bootloader {
	efibootmgr
	clear
	echo -e "${red}${bold}should I remove your UEFI bootloader?
	1) yes
	2) no${reset}"
	read uefi_arg
	[ "$uefi_arg" == "1" ] && uefi_list
}
function uefi_list {
	clear
	echo -e "${red}${bold}set number of the bootloader(0001,0002..etc)${reset}"
	efibootmgr -v
	read uefi_arg
	efibootmgr -b $uefi_arg -B
	bootloader
}
function pewpew {
	arch-chroot /mnt bash grubinstall.sh
}
### Bootloader END

### Trim BEGIN
function detect_trim_support {
	hdparm -I $membrane | grep TRIM && trim_enabler
}
function trim_enabler {
	clear
	echo -e "${red}${bold}your disk does support trim should I enable it?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && touch trim
}
### Trim END

### yay BEGIN
function yay {
	clear
	echo -e "${red}${bold}should I install yay(AUR helper)?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && yay_install
}
function yay_install {
	cp yay.sh /mnt
	cp yay-11.2.0-1-x86_64.pkg.tar.zst /mnt
	arch-chroot /mnt bash yay.sh
}
### yay END

### everything else BEGIN
function manual_mode_settings {
	partition_another_disk_part1
	check_BIOS
	install_swap
	home
}
function check_BIOS {
	find 2 && formatforBIOS || formatforUEFI
}
function swap {
	clear
	echo -e "${red}${bold}set your swap partition${reset}"
	lsblk
	read part3
	mkswap $part3
	swapon $part3
}
function partition_another_disk_part1 {
	clear
	echo -e "${red}${bold}should I partition another disk?
	1) yes
	2) no${reset}"
	read answr7
	[ "$answr7" == "1" ] && partition_another_disk_part2
}
function partition_another_disk_part2 {
	clear
	echo -e "${red}${bold}set your disk${reset}"
	lsblk
	read answr7
	cfdisk $answr7
}
function remove_garbage {
	ls /mnt | grep -w "grubinstall.sh" && rm /mnt/grubinstall.sh
	ls /mnt | grep -w "userland.sh" && rm /mnt/userland.sh
	ls /mnt | grep -w "encrypt" && rm /mnt/encrypt
	ls /mnt | grep -w "mkinitcpio.conf" && rm /mnt/mkinitcpio.conf
	ls /mnt | grep -w "trim" && rm /mnt/trim
	ls /mnt | grep -w "yay.sh" && rm /mnt/yay.sh
	ls /mnt | grep -w "2" && rm /mnt/2
	ls /mnt | grep -w "file_for_grub" && rm /mnt/file_for_grub
	ls /mnt | grep -w "yay-11.2.0-1-x86_64.pkg.tar.zst" && rm /mnt/yay-11.2.0-1-x86_64.pkg.tar.zst
}
function install_base_system {
	clear
	echo -e "${red}${bold}Setting up optimal mirrors please wait...${reset}"
	reflector --latest 50 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
	clear
	echo -e "${red}${bold}set your kernel
	1) Stable (stable kernel)
	2) Hardened (more secure kernel)
	3) LTS (long term support kernel)
	4) Zen Kernel (Zen patched kernel)${reset}"
	read kernel
	[ "$kernel" == "1" ] && pacstrap /mnt base linux linux-firmware dhcpcd nano gvim mc exfat-utils btrfs-progs ntfs-3g htop dosfstools && touch LINUX
	[ "$kernel" == "2" ] && pacstrap /mnt base linux-hardened linux-firmware dhcpcd nano gvim mc exfat-utils btrfs-progs ntfs-3g htop dosfstools && touch HARD
	[ "$kernel" == "3" ] && pacstrap /mnt base linux-lts linux-firmware dhcpcd nano gvim mc exfat-utils btrfs-progs ntfs-3g htop dosfstools && touch LTS
	[ "$kernel" == "4" ] && pacstrap /mnt base linux-zen linux-firmware dhcpcd nano gvim mc exfat-utils btrfs-progs ntfs-3g htop dosfstools && touch ZEN
}
function copy_files {
	echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf
	cp userland.sh /mnt
	cp grubinstall.sh /mnt
	echo "KEYMAP=us" >> /mnt/etc/vconsole.conf
	cp encrypt /mnt
	cp mkinitcpio.conf /mnt
	echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
	cp trim /mnt
	cp file_for_grub /mnt
	find home_key && cp home_key /mnt
}
function install_swap {
	clear
	echo -e "${red}${bold}should I install swap partition?
	1) yes
	2) no${reset}"
	read answr3
	[ "$answr3" == "1" ] && swap
}
function vim_fix {
	echo "set clipboard=unnamedplus" >> /mnt/etc/vimrc
	echo "set mouse=a" >> /mnt/etc/vimrc
	echo "set number" >> /mnt/etc/vimrc
}

### everything else END
efibootmgr || touch 2
find 2 || bootloader
disk_to_install
detect_trim_support
find auto || manual_mode_settings
install_base_system
copy_files
arch-chroot /mnt bash userland.sh
ls | grep 2 && mv 2 /mnt
ls /mnt | grep 2 && pewpew || booter
check_for_home_encryption
ln -sf /usr/share/zoneinfo/"$(curl --fail https://ipapi.co/timezone)" /mnt/etc/localtime
yay
create_fstab_file
remove_garbage
vim_fix
clear
echo -e "${red}${bold}Installation is complete!!!${reset}"
