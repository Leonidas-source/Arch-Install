#!/bin/bash
function secure {
  ls | grep LINUX && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'rd.luks.name='$ESP4'=cryptroot root=/dev/mapper/cryptroot rw initrd=\initramfs-linux.img'
  ls | grep ZEN && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Zen" --loader  /vmlinuz-linux-zen  --unicode 'rd.luks.name='$ESP4'=cryptroot root=/dev/mapper/cryptroot rw initrd=\initramfs-linux-zen.img'
  ls | grep LTS && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Lts" --loader  /vmlinuz-linux-lts  --unicode 'rd.luks.name='$ESP4'=cryptroot root=/dev/mapper/cryptroot rw initrd=\initramfs-linux-lts.img'
  ls | grep HARD && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Hard" --loader  /vmlinuz-linux-hardened  --unicode 'rd.luks.name='$ESP4'=cryptroot root=/dev/mapper/cryptroot rw initrd=\initramfs-linux-hardened.img'
}
function regular {
  clear
  ls | grep LINUX && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux.img'
  ls | grep ZEN && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Zen" --loader  /vmlinuz-linux-zen  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux-zen.img'
  ls | grep LTS && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Lts" --loader  /vmlinuz-linux-lts  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux-lts.img'
  ls | grep HARD && efibootmgr --disk $ESP --part $ESP2 --create --label "Arch_Hard" --loader  /vmlinuz-linux-hardened  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux-hardened.img'
}
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
ESP4=$(lsblk -f $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
ls | grep -w "encrypt" && secure || regular
exit
