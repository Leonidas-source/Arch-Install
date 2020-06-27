#!/bin/bash
lsblk -f
echo "Set your disk(not partition) with EFI"
read disk
clear
lsblk -f
echo "Set number of your EFI partition(1,2,3,4,5....)"
read number
clear
lsblk -f
echo "Set your root partition"
read badboyyy
efibootmgr --disk $disk --part $number --create --label "Arch" --loader /vmlinuz-linux --unicode 'root=$badboyyy  rw initrd=\initramfs-linux.img' 
