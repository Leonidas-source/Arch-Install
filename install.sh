#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
function erasedisk {
	clear
	echo -e "${red}${bold}set your disk${reset}"
	lsblk
	read disk
	clear
	echo -e "${red}${bold}set mode of erasing
	1) auto
	2) manual${reset}"
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
	echo -e "${red}${bold}set your block size${reset}"
	read block
	clear
	echo -e "${red}${bold}set your input(count)${reset}"
	read input
	clear
	echo -e "${red}${bold}select source
	1) zero
	2) urandom${reset}"
	read zeroing
	[ "$zeroing" == "1" ] && dd if=/dev/zero of=$disk bs=$block count=$input status=progress
	[ "$zeroing" == "2" ] && dd if=/dev/urandom of=$disk bs=$block count=$input status=progress iflag=fullblock
}
function once_more {
	clear
	echo -e "${red}${bold}Should I erase another disk?
	1) yes
	2) no${reset}"
	read addit
	[ "$addit" == "1" ] && erasedisk
}
function system {
	clear
	echo -e "${red}${bold}set your system
	1) BIOS
	2) UEFI${reset}"
	read some
	[ "$some" == "1" ] && touch 2
}
function check_BIOS {
	ls | grep 2 && formatforBIOS || formatforUEFI
}
function formatforBIOS {
	clear
	echo -e "${red}${bold}set you / partition${reset}"
	lsblk
	read root
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read answr6
	[ "$answr6" == "1" ] && format_root_BIOS
	clear
	mount $root /mnt
}
function format_root_BIOS {
	echo -e "${red}${bold}set filesystem for /
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat${reset}"
	read filese
	[ "$filese" == "1" ] && mkfs.ext4 $root
	[ "$filese" == "2" ] && mkfs.ext3 $root
	[ "$filese" == "3" ] && mkfs.xfs $root
	[ "$filese" == "4" ] && btrfser
	[ "$filese" == "5" ] && mkfs.ext2 $root
	[ "$filese" == "6" ] && mkfs.vfat $root
	[ "$filese" == "7" ] && mkfs.exfat $root
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
function formatforUEFI {
	clear
	echo -e "${red}${bold}set your EFI partition${reset}"
	lsblk
	read part1
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read answr5
	[ "$answr5" == "1" ] && format_efi
	clear
	echo -e "${red}${bold}set your / partition${reset}"
	lsblk
	read -e ESP3
	echo $ESP3 | cat >> root_partition
	encryption
	clear
	echo -e "${red}${bold}should I format it?
	1) yes
	2) no${reset}"
	read answr4
	[ "$answr4" == "1" ] && format_root
	clear
	mount $ESP3 /mnt
	mkdir /mnt/boot
	create_boot_entry
	mount $part1 /mnt/boot
}
function format_efi {
	echo -e "${red}${bold}set your filesystem for EFI partition
	1) FAT32
	2) EXFAT${reset}"
	read EXFAT
	[ "$EXFAT" == "1" ] && mkfs.vfat $part1
	[ "$EXFAT" == "2" ] && mkfs.exfat $part1 && touch nobootloader
}
function encryption {
	clear
	echo -e "${red}${bold}should I encrypt root partition?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && root_encryption
}
function root_encryption {
	clear
	cryptsetup luksFormat $ESP3
	cryptsetup open $ESP3 root
	touch encrypt
}
function format_root {
	ls | grep -w "encrypt" && ESP3=/dev/mapper/root
	clear
	echo -e "${red}${bold}set filesystem for /
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat${reset}"
	read filesys
	[ "$filesys" == "1" ] && mkfs.ext4 $ESP3
	[ "$filesys" == "2" ] && mkfs.ext3 $ESP3
	[ "$filesys" == "3" ] && mkfs.xfs $ESP3
	[ "$filesys" == "4" ] && ohhmanifeelsosleepy
	[ "$filesys" == "5" ] && mkfs.ext2 $ESP3
	[ "$filesys" == "6" ] && mkfs.vfat $ESP3
	[ "$filesys" == "7" ] && mkfs.exfat $ESP3
}
function ohhmanifeelsosleepy {
	clear
	mkfs.btrfs $ESP3
	mkdir test
	mount $ESP3 test
	btrfs subvolume create test/root
	btrfs subvolume set-default 256 test
	umount $ESP3
	clear
	echo -e "${red}${bold}set your compression type
	1) zlib
	2) lzo
	3) zstd
	4) no compression${reset}"
	read rofl
	[ "$rofl" == "1" ] && touch zlib_root
	[ "$rofl" == "2" ] && touch lzo_root
	[ "$rofl" == "3" ] && touch zstd_root
	[ "$rofl" == "4" ] && touch nocom_root
}
function swap {
	clear
	echo -e "${red}${bold}set your swap partition${reset}"
	lsblk
	read part3
	mkswap $part3
	swapon $part3
}
function home {
	clear
	echo -e "${red}${bold}should I set home partition?
	1) yes
	2) no${reset}"
	read home
	[ "$home" == "1" ] && home_set
}
function home_set {
	clear
	echo -e "${red}${bold}should I encrypt /home
	1) yes
	2) no${reset}"
	read home
	[ "$home" == "1" ] && home_encryption
	ls | grep -w "encrypt_for_home" && formathome
	ls | grep -w "encrypt_for_home" || installhome
}
function home_encryption {
	clear
	echo -e "${red}${bold}set home partition${reset}"
	lsblk
	read home_encrypted
	cryptsetup luksFormat $home_encrypted
	cryptsetup open $home_encrypted secure_home
	touch encrypt_for_home
}
function installhome {
	clear
	touch installhome_config
	echo -e "${red}${bold}set your home partition${reset}"
	lsblk
	read -e homepart
	clear
	echo -e "${red}${bold}should i format it?
	1) yes
	2) no${reset}"
	read somehome
	[ "$somehome" == "1" ] && formathome
	ls /mnt | grep -w "home" || mkdir /mnt/home
	ls | grep -w "home_entry" && compression
	create_home_entry
}
function formathome {
	ls | grep -w "encrypt_for_home" && homepart=/dev/mapper/secure_home
	clear
	echo -e "${red}${bold}set your filesystem for /home
	1) ext4
	2) ext3
	3) xfs
	4) btrfs
	5) ext2
	6) fat32
	7) exfat${reset}"
	read idea
	[ "$idea" == "1" ] && mkfs.ext4 $homepart
	[ "$idea" == "2" ] && mkfs.ext3 $homepart
	[ "$idea" == "3" ] && mkfs.xfs $homepart
	[ "$idea" == "4" ] && btrfserforhome
	[ "$idea" == "5" ] && mkfs.ext2 $homepart
	[ "$idea" == "6" ] && mkfs.vfat $homepart
	[ "$idea" == "7" ] && mkfs.exfat $homepart
	ls | grep -w "installhome_config" || compensation
}
function btrfserforhome {
	clear
	mkfs.btrfs $homepart
	mkdir fuckme
	mount $homepart fuckme
	btrfs subvolume create fuckme/home
	btrfs subvolume set-default 256 fuckme
	umount $homepart
	compression
	create_home_entry
	touch create_home_entry_file
}
function create_home_entry {
	ls | grep -w "zlib" && var=,compress-force=zlib
	ls | grep -w "lzo" && var=,compress-force=lzo
	ls | grep -w "zstd" && var=,compress-force=zstd
	touch home.mount
	echo "[Unit]" >> home.mount
	echo "Description=home partition" >> home.mount
	echo " " >> home.mount
	echo "[Mount]" >> home.mount
	oohmy=$(lsblk -fd $homepart -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "What=/dev/disk/by-uuid/$oohmy" >> home.mount
	echo "Where=/home" >> home.mount
	oohmy2=$(lsblk -fd $homepart -o FSTYPE | sed s/"FSTYPE"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "Type=$oohmy2" >> home.mount
	echo "Options=rw$var" >> home.mount
	echo " " >> home.mount
	echo "[Install]" >> home.mount
	echo "WantedBy=multi-user.target" >> home.mount
}
function compensation {
	ls /mnt | grep -w "home" || mkdir /mnt/home
	create_home_entry
	ls | grep -w "create_home_entry_file" || mount $homepart /mnt/home
}
function compression {
	clear
	echo -e "${red}${bold}set your compression
	1) zlib
	2) lzo
	3) zstd
	4) no compression${reset}"
	read compress
	[ "$compress" == "1" ] && (mount -o compress-force=zlib $homepart /mnt/home && touch zlib)
	[ "$compress" == "2" ] && (mount -o compress-force=lzo $homepart /mnt/home && touch lzo)
	[ "$compress" == "3" ] && (mount -o compress-force=zstd $homepart /mnt/home && touch zstd)
	[ "$compress" == "4" ] && mount $homepart /mnt/home
	touch compression_file
}
function create_boot_entry {
	touch boot.mount
	echo "[Unit]" >> boot.mount
	echo "Description=boot partition" >> boot.mount
	echo " " >> boot.mount
	echo "[Mount]" >> boot.mount
	bootle=$(lsblk -f $part1 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "What=/dev/disk/by-uuid/$bootle" >> boot.mount
	echo "Where=/boot" >> boot.mount
	bootle2=$(lsblk -f $part1 -o FSTYPE | sed s/"FSTYPE"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "Type=$bootle2" >> boot.mount
	echo " " >> boot.mount
	echo "[Install]" >> boot.mount
	echo "WantedBy=multi-user.target" >> boot.mount
}
function booter {
	clear
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
function check_for_home_encryption {
	clear
	ls | grep -w "encrypt_for_home" && securetab
}
function securetab {
	clear
	rm /mnt/etc/crypttab
	touch /mnt/etc/crypttab
	Calc=$(lsblk -fd $home_encrypted -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "secure_home UUID=$Calc none luks,timeout=120" >> /mnt/etc/crypttab
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
function bootloader {
	clear
	efibootmgr
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
pewpew() {
	arch-chroot /mnt bash grubinstall.sh
}
bootloader
clear
echo -e "${red}${bold}should I erase your disk?
1) yes
2) no${reset}"
read answr
[ "$answr" == "1" ] && erasedisk
clear
echo -e "${red}${bold}set disk to install Arch Linux${reset}"
lsblk
read membrane
clear
cfdisk $membrane
partition_another_disk_part1
clear
system
check_BIOS
clear
echo -e "${red}${bold}should I install swap partition?
1) yes
2) no${reset}"
read answr3
[ "$answr3" == "1" ] && swap
clear
home
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
[ "$kernel" == "1" ] && pacstrap /mnt base linux linux-firmware polkit dhcpcd nano mc exfat-utils btrfs-progs && touch LINUX
[ "$kernel" == "2" ] && pacstrap /mnt base linux-hardened linux-firmware dhcpcd nano mc exfat-utils btrfs-progs && touch HARD
[ "$kernel" == "3" ] && pacstrap /mnt base linux-lts linux-firmware polkit dhcpcd nano mc exfat-utils btrfs-progs && touch LTS
[ "$kernel" == "4" ] && pacstrap /mnt base linux-zen linux-firmware polkit dhcpcd nano mc exfat-utils btrfs-progs && touch ZEN
clear
mv locale.conf /mnt/etc
mv userland.sh /mnt
mv grubinstall.sh /mnt
mv boot.mount /mnt
ls | grep -w "home.mount" && mv home.mount /mnt
mv vconsole.conf /mnt/etc
cp encrypt /mnt
mv mkinitcpio.conf /mnt
cp locale.gen /mnt
arch-chroot /mnt bash userland.sh
clear
ls | grep 2 && mv 2 /mnt
ls /mnt | grep 2 && pewpew || booter
clear
rm /mnt/grubinstall.sh
rm /mnt/userland.sh
ls /mnt | grep -w "encrypt" && rm /mnt/encrypt
ls /mnt | grep -w "mkinitcpio.conf" && rm /mnt/mkinitcpio.conf
check_for_home_encryption
ln -sf /usr/share/zoneinfo/"$(curl --fail https://ipapi.co/timezone)" /mnt/etc/localtime
clear
echo -e "${red}${bold}Installation is complete!!!${reset}"
