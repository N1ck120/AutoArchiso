#!/bin/bash
if ! pacman -Qi archiso > /dev/null 2>/dev/null; then
    yes|LC_ALL=en_US.UTF-8 sudo pacman -S archiso
fi
echo -e "Select device\n"
lsblk -dmo NAME,SIZE,MODEL,MOUNTPOINT  | grep sd | grep -v $(mount | grep 'on / ' | cut -d' ' -f1 | sed 's/[0-9]*$//')
echo -e "\n"

echo "Select the desired unit ex: sdb"

read usbdrive

sudo mkarchiso -v -w /tmp/archiso-tmp -o $HOME/archiso/ /usr/share/archiso/configs/releng/

cd $HOME/archiso/

mv archlinux-"$(date +%Y.%m.%d)"-x86_64.iso arch.iso

dd bs=4M if=$HOME/archiso/arch.iso of=/dev/$usbdrive conv=fsync oflag=direct status=progress

sudo rm -rf /tmp/archiso-tmp $HOME/archiso

