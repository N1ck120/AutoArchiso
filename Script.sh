#!/bin/bash
if [[ $EUID -eq 0 ]]; then
  current_user=$(logname)
  home_dir=$(eval echo ~$current_user)
else
  home_dir=$HOME
fi

if ! pacman -Qi archiso > /dev/null 2>/dev/null; then
    sudo pacman -S --noconfirm archiso 
fi
echo -e "Select device\n"
lsblk -dmo NAME,SIZE,MODEL,MOUNTPOINT  | grep sd | grep -v $(mount | grep 'on / ' | cut -d' ' -f1 | sed 's/[0-9]*$//')
echo -e "\n"

echo "Select the desired unit ex: sdb"

read usbdrive

mkdir $home_dir/archiso/

sudo mkarchiso -v -w /tmp/archiso-tmp -o $home_dir/archiso/ /usr/share/archiso/configs/releng/

cd $home_dir/archiso/

mv * arch.iso

dd bs=4M if=$home_dir/archiso/arch.iso of=/dev/$usbdrive conv=fsync oflag=direct status=progress

sudo rm -rf /tmp/archiso-tmp $home_dir/archiso

