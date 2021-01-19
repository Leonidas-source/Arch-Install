#!/bin/bash
source_path=$(pwd)
arch-chroot /mnt bootctl install
function loader {
  cd /mnt/boot/loader/
  echo "default arch.conf" | cat >> loader.conf
  echo "timeout  5" | cat >> loader.conf
  echo "console-mode max" | cat >> loader.conf
  echo "editor   no" | cat >> loader.conf
}
function entry {
  cd $source_path
  touch arch.conf
  mv arch.conf /mnt/boot/entries/
  echo "title   Arch Linux" | cat >> /mnt/boot/entries/arch.conf
  ls | grep LINUX && echo "linux   /vmlinuz-linux" | cat >> /mnt/boot/entries/arch.conf
  ls | grep HARD && echo "linux   /vmlinuz-linux-hardened" | cat >> /mnt/boot/entries/arch.conf
  ls | grep LTS && echo "linux   /vmlinuz-linux-lts" | cat >> /mnt/boot/entries/arch.conf
  ls | grep ZEN && echo "linux   /vmlinuz-linux-zen" | cat >> /mnt/boot/entries/arch.conf

  echo "title   Arch Linux" | cat >> /mnt/boot/entries/arch.conf
}
function entry_two {
  ls | grep LINUX && echo "initrd  /initramfs-linux.img" | cat >> /mnt/boot/entries/arch.conf
  ls | grep HARD && echo "initrd  /initramfs-linux-hardened.img" | cat >> /mnt/boot/entries/arch.conf
  ls | grep LTS && echo "initrd  /initramfs-linux-lts.img" | cat >> /mnt/boot/entries/arch.conf
  ls | grep ZEN && echo "initrd  /initramfs-linux-zen.img" | cat >> /mnt/boot/entries/arch.conf
}
loader
entry
entry_two
echo "Set / partition"
read ESP3
clear
ESP4=$(lsblk -f $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
echo "options "root=UUID='$ESP4' " rw
