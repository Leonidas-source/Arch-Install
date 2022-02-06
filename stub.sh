#!/bin/bash
red="\e[0;91m"
bold="\e[1m"
reset="\e[0m"
function secure {
  ls | grep LINUX && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'rd.luks.uuid='$ESP4' root=/dev/mapper/root rw initrd=\initramfs-linux.img'
  ls | grep ZEN && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Zen" --loader  /vmlinuz-linux-zen  --unicode 'rd.luks.uuid='$ESP4' root=/dev/mapper/root rw initrd=\initramfs-linux-zen.img'
  ls | grep LTS && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Lts" --loader  /vmlinuz-linux-lts  --unicode 'rd.luks.uuid='$ESP4' root=/dev/mapper/root rw initrd=\initramfs-linux-lts.img'
  ls | grep HARD && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Hard" --loader  /vmlinuz-linux-hardened  --unicode 'rd.luks.uuid='$ESP4' root=/dev/mapper/root rw initrd=\initramfs-linux-hardened.img'
}
function regular {
  clear
  ls | grep LINUX && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux.img'
  ls | grep ZEN && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Zen" --loader  /vmlinuz-linux-zen  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux-zen.img'
  ls | grep LTS && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Lts" --loader  /vmlinuz-linux-lts  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux-lts.img'
  ls | grep HARD && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Hard" --loader  /vmlinuz-linux-hardened  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux-hardened.img'
}
clear
echo -e "${red}${bold}Set your drive(not partition) with ESP${reset}"
lsblk
read ESP
clear
echo -e "${red}${bold}Set number of that(ESP) partition (1,2,3,4)${reset}"
lsblk $ESP
read ESP2
clear
echo -e "${red}${bold}Set / partition${reset}"
lsblk
read ESP3
clear
ESP4=$(lsblk -fd $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
ls | grep -w "encrypt" && secure || regular
