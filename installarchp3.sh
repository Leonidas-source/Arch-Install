#!/bin/bash
lsblk -f | cat >> installarchp3.sh
vim installarchp3.sh
#efibootmgr --disk /dev/sdX --part Y --create --label "Arch Linux" --loader /vmlinuz-linux --unicode 'root=UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX  rw initrd=\initramfs-linux.img'
sh installarchp3.sh
