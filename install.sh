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
function check_BIOS {
	ls | grep 2 && formatforBIOS || formatforUEFI
}
function once_more {
	clear
	echo -e "${red}${bold}Should I erase your disk once more?
	1) Yes
	2) No${reset}"
	read addit
	[ "$addit" == "1" ] && erasedisk
}
function erasedisk {
	clear
	lsblk
	echo -e "${red}${bold}Set your disk${reset}"
	read disk
	clear
	echo -e "${red}${bold}Set mode of erasing
	1) Auto
	2) Manual${reset}"
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
	echo -e "${red}${bold}Set your block size${reset}"
	read block
	clear
	echo -e "${red}${bold}Set your input(count)${reset}"
	read input
	clear
	echo -e "${red}${bold}Select source
	1) zero
	2) urandom${reset}"
	read zeroing
	[ "$zeroing" == "1" ] && dd if=/dev/zero of=$disk bs=$block count=$input status=progress
	[ "$zeroing" == "2" ] && dd if=/dev/urandom of=$disk bs=$block count=$input status=progress iflag=fullblock
}
function format_root {
	echo -e "${red}${bold}Set filesystem for /
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
function format_efi {
	echo -e "${red}${bold}Set your filesystem for EFI partition
	1) FAT32
	2) EXFAT${reset}"
	read EXFAT
	[ "$EXFAT" == "1" ] && mkfs.vfat $part1
	[ "$EXFAT" == "2" ] && mkfs.exfat $part1
}
function formatforUEFI {
	clear
	lsblk
	echo -e "${red}${bold}Set your EFI partition${reset}"
	read part1
	echo -e "${red}${bold}Should I format it?
	1) yes
	2) no${reset}"
	read answr5
	[ "$answr5" == "1" ] && format_efi
	clear
	lsblk
	echo -e "${red}${bold}Set your / partition${reset}"
	read -e ESP3
	echo -e "${red}${bold}Should I format it?
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
	lsblk
	echo -e "${red}${bold}Set your Swap partition${reset}"
	read part3
	mkswap $part3
	swapon $part3
}
function system {
	clear
	echo -e "${red}${bold}Set your system
	1) BIOS
	2) UEFI${reset}"
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
	echo -e "${red}${bold}Set filesystem for /
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
function formatforBIOS {
	clear
	lsblk
	echo -e "${red}${bold}Set you / partition${reset}"
	read root
	echo -e "should i format it?
	1) yes
	2) no${reset}"
	read answr6
	[ "$answr6" == "1" ] && format_root_BIOS
	clear
	mount $root /mnt
}
function home {
	clear
	echo -e "${red}${bold}Should I set home partition?
	1) Yes
	2) No${reset}"
	read home
	[ "$home" == "1" ] && installhome
}
function installhome {
	clear
	echo -e "${red}${bold}Should I erase disk with future home partition?
	1) Yes
	2) No${reset}"
	read may
	[ "$may" == "1" ] && rmhome
	clear
	lsblk
	echo -e "${red}${bold}Set your home partition${reset}"
	read -e homepart
	clear
	echo -e "${red}${bold}Should I format it?
	1) Yes
	2) No${reset}"
	read somehome
	[ "$somehome" == "1" ] && formathome
	mkdir /mnt/home
	compression
	create_home_entry
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
	[ "$compress" == "4" ] && (mount $homepart /mnt/home && touch nocom)
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
	ls | grep -w "zlib" && echo "Options=compress-force=zlib" | cat >> home.mount
	ls | grep -w "lzo" && echo "Options=compress-force=lzo" | cat >> home.mount
	ls | grep -w "zstd" && echo "Options=compress-force=zstd" | cat >> home.mount
	ls | grep -w "nocom" && echo " " | cat >> home.mount
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
	echo -e "${red}${bold}Set your filesystem for /home
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
}
function booter {
	clear
	echo -e "${red}${bold}Set your bootloader
	1) grub
	2) EFISTUB
	3) systemd-boot
	4) none${reset}"
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
	echo -e "${red}${bold}Enter root partition${reset}"
	read root_partition
	i_forgot=$(lsblk -f $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	ESP4=$(lsblk -f $root_partition -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	ls | grep -w "zlib_root" && var=$(echo "compress-force=zlib")
	ls | grep -w "lzo_root" && var=$(echo "compress-force=lzo")
	ls | grep -w "zstd_root" && var=$(echo "compress-force=zstd")
	ls | grep -w "encrypt" && echo "options rd.luks.name="$ESP4"=root_partition root="'"'UUID="$i_forgot"'"' " rw $var" | cat >> /mnt/boot/loader/entries/arch.conf ; touch already
	ls | grep -w "already" || echo "options root="'"'UUID="$ESP4"'"' " rw $var" | cat >> /mnt/boot/loader/entries/arch.conf
}
function pewpew {
	arch-chroot /mnt sh grubinstall.sh
}
function encryption {
	clear
	echo -e "${red}${bold}Should I encrypt root partition?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && root_encryption
}
function root_encryption {
	clear
	lsblk
	echo -e "${red}${bold}Set root partition${reset}"
	read answr
	cryptsetup luksFormat $answr
	cryptsetup open $answr root
	touch encrypt
}
function encryption_for_home {
	clear
	echo -e "${red}${bold}Should I encrypt home partition?
	1) yes
	2) no${reset}"
	read answr
	[ "$answr" == "1" ] && home_encryption
}
function home_encryption {
	clear
	lsblk
	echo -e "${red}${bold}Set home partition${reset}"
	read home_encrypted
	cryptsetup luksFormat $home_encrypted
	cryptsetup open $home_encrypted secure_home
	touch encrypt_for_home
}
function check_for_home_encryption {
	clear
	ls | grep -w "encrypt_for_home" && securetab
}
function securetab {
	clear
	rm /mnt/etc/crypttab
	touch /mnt/etc/crypttab
	Calc=$(lsblk -f $home_encrypted -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
	echo "secure_home UUID=$Calc none luks,timeout=120" | cat >> /mnt/etc/crypttab
}
reserve_thing=$(pwd)
clear
echo -e "${red}${bold}Should I Erase your disk?
1) Yes
2) No${reset}"
read answr
[ "$answr" == "1" ] && erasedisk
clear
lsblk
echo -e "${red}${bold}Set disk to install Arch Linux${reset}"
read membrane
clear
cfdisk $membrane
encryption
encryption_for_home
clear
system
check_BIOS
clear
echo -e "${red}${bold}Should I install Swap partiotion?
1) Yes
2) No${reset}"
read answr3
[ "$answr3" == "1" ] && swap
clear
home
clear
rm /etc/pacman.d/mirrorlist
mv mirrorlist /etc/pacman.d/
nano /etc/pacman.d/mirrorlist
clear
echo -e "${red}${bold}Set your kernel
1)Stable(default)
2)Hardened(more secure)
3)LTS(long time support)
4)Zen Kernel(Zen Patched Kernel)${reset}"
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
mv vconsole.conf /mnt/etc/
cp encrypt /mnt
mv mkinitcpio.conf /mnt
arch-chroot /mnt sh userland.sh
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
