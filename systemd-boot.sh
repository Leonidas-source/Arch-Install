#!/bin/bash
function loader {
  cd /boot/loader/
  rm loader.conf
  touch loader.conf
  echo "default arch.conf" | cat >> loader.conf
  echo "timeout  5" | cat >> loader.conf
  echo "console-mode max" | cat >> loader.conf
  echo "editor   no" | cat >> loader.conf
}
function entry {
  cd /boot/entries/
  touch arch.conf
  cd /
  echo "title   Arch Linux" | cat >> /boot/entries/arch.conf
  ls | grep LINUX && echo "linux   /vmlinuz-linux" | cat >> /boot/entries/arch.conf
  ls | grep HARD && echo "linux   /vmlinuz-linux-hardened" | cat >> /boot/entries/arch.conf
  ls | grep LTS && echo "linux   /vmlinuz-linux-lts" | cat >> /boot/entries/arch.conf
  ls | grep ZEN && echo "linux   /vmlinuz-linux-zen" | cat >> /boot/entries/arch.conf
}
function entry_two {
  ls | grep LINUX && echo "initrd  /initramfs-linux.img" | cat >> /boot/entries/arch.conf
  ls | grep HARD && echo "initrd  /initramfs-linux-hardened.img" | cat >> /boot/entries/arch.conf
  ls | grep LTS && echo "initrd  /initramfs-linux-lts.img" | cat >> /boot/entries/arch.conf
  ls | grep ZEN && echo "initrd  /initramfs-linux-zen.img" | cat >> /boot/entries/arch.conf
}
loader
entry
entry_two
lsblk
echo "Set / partition"
read ESP3
clear
ESP4=$(lsblk -f $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
echo "options "root=UUID='$ESP4' " rw " | cat >> /boot/entries/arch.conf
exit
