#!/bin/bash
lsblk -f | cat >> installarchp3.sh
vim installarchp3.sh
#efibootmgr --disk  --part  --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=UUID=  rw initrd=\initramfs-linux.img'
sh installarchp3.sh
