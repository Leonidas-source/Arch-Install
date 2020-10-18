#!/bin/bash
clear
lsblk
echo "Set your drive(not partition) with ESP"
read ESP
clear
lsblk $ESP
echo "Set number of that(ESP) partition (1,2,3,4)"
read ESP2
clear
lsblk
echo "Set / partition"
read ESP3
clear
ESP4=$(lsblk -f $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
clear
efibootmgr --disk $ESP --part $ESP2 --create --label "Arch" --loader  /vmlinuz-linux  --unicode 'root=UUID='$ESP4' rw initrd=\initramfs-linux.img'
exit
