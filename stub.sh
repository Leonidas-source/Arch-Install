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
function secure {
  ls | grep LINUX && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'rd.luks.name='$ESP4'=root root=/dev/mapper/root rw '$addsettings' initrd=\initramfs-linux.img'
  ls | grep ZEN && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Zen" --loader  /vmlinuz-linux-zen  --unicode 'rd.luks.name='$ESP4'=root root=/dev/mapper/root rw '$addsettings' initrd=\initramfs-linux-zen.img'
  ls | grep LTS && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Lts" --loader  /vmlinuz-linux-lts  --unicode 'rd.luks.name='$ESP4'=root root=/dev/mapper/root rw '$addsettings' initrd=\initramfs-linux-lts.img'
  ls | grep HARD && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Hard" --loader  /vmlinuz-linux-hardened  --unicode 'rd.luks.name='$ESP4'=root root=/dev/mapper/root rw '$addsettings' initrd=\initramfs-linux-hardened.img'
}
function regular {
  clear
  ls | grep LINUX && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'root=UUID='$ESP4' rw '$addsettings' initrd=\initramfs-linux.img'
  ls | grep ZEN && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Zen" --loader  /vmlinuz-linux-zen  --unicode 'root=UUID='$ESP4' rw '$addsettings' initrd=\initramfs-linux-zen.img'
  ls | grep LTS && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Lts" --loader  /vmlinuz-linux-lts  --unicode 'root=UUID='$ESP4' rw '$addsettings' initrd=\initramfs-linux-lts.img'
  ls | grep HARD && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Hard" --loader  /vmlinuz-linux-hardened  --unicode 'root=UUID='$ESP4' rw '$addsettings' initrd=\initramfs-linux-hardened.img'
}
ls | grep -w "zlib_root" && addsettings=$(echo "compress-force=zlib")
ls | grep -w "lzo_root" && addsettings=$(echo "compress-force=lzo")
ls | grep -w "zstd_root" && addsettings=$(echo "compress-force=zstd")
clear
lsblk
echo -e "${red}${bold}Set your drive(not partition) with ESP${reset}"
read ESP
clear
lsblk $ESP
echo -e "${red}${bold}Set number of that(ESP) partition (1,2,3,4)${reset}"
read ESP2
clear
lsblk
echo -e "${red}${bold}Set / partition${reset}"
read ESP3
clear
ESP4=$(lsblk -fd $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
ls | grep -w "encrypt" && secure || regular
