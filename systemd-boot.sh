#!/bin/bash
function flexer {
  cd /boot/loader/
  rm loader.conf
  touch loader.conf
  echo "default arch.conf" | cat >> loader.conf
  echo "timeout  5" | cat >> loader.conf
  echo "console-mode max" | cat >> loader.conf
  echo "editor   no" | cat >> loader.conf
}
function entry {
  mkdir /boot/loader/entries
  cd /boot/loader/entries
  touch arch.conf
  cd /
  echo "title   Arch Linux" | cat >> /boot/loader/entries/arch.conf
  ls | grep LINUX && echo "linux   /vmlinuz-linux" | cat >> /boot/loader/entries/arch.conf
  ls | grep HARD && echo "linux   /vmlinuz-linux-hardened" | cat >> /boot/loader/entries/arch.conf
  ls | grep LTS && echo "linux   /vmlinuz-linux-lts" | cat >> /boot/loader/entries/arch.conf
  ls | grep ZEN && echo "linux   /vmlinuz-linux-zen" | cat >> /boot/loader/entries/arch.conf
}
function entry_two {
  ls | grep LINUX && echo "initrd  /initramfs-linux.img" | cat >> /boot/loader/entries/arch.conf
  ls | grep HARD && echo "initrd  /initramfs-linux-hardened.img" | cat >> /boot/loader/entries/arch.conf
  ls | grep LTS && echo "initrd  /initramfs-linux-lts.img" | cat >> /boot/loader/entries/arch.conf
  ls | grep ZEN && echo "initrd  /initramfs-linux-zen.img" | cat >> /boot/loader/entries/arch.conf
}
flexer
entry
entry_two
lsblk
echo "Set / partition"
read ESP3
clear
ESP4=$(lsblk -f $ESP3 -o UUID | sed s/"UUID"/""/g | sed '/^$/d;s/[[:blank:]]//g')
echo "options "'"'root=UUID="$ESP4"'"' " rw " | cat >> /boot/loader/entries/arch.conf
exit
