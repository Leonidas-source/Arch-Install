#!/bin/bash
function user {
	echo "Set name for your user"
	read name
	useradd -m $name
	clear
	echo "Set password for your user"
	passwd $name
	echo "Done"
}
ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
nano /etc/locale.gen
clear
locale-gen
clear
echo "Set your hostname"
echo "To exit use CTRL+D"
cat > /etc/hostname
echo "Done"
clear
echo "Set your root password"
passwd
echo "Done"
echo "Should I add user(yes/no)?"
read answr
[ "$answr" == "yes" ] && user
clear
echo "Should I enable dhcpcd(yes/no)?"
read dhcp
[ "$dhcp" == "yes" ] && systemctl enable dhcpcd
exit

