https://wiki.gentoo.org/wiki/Handbook:AMD64

https://wiki.gentoo.org/wiki/Systemd/Installing_Gnome3_from_scratch

https://wiki.gentoo.org/wiki/Handbook:Parts/Working/Portage/en

https://github.com/Pednick/archlinux

https://wiki.gentoo.org/wiki/ALSA#Hardware_detection

localectl set-locale LANG=en_CA.UTF-8

ln -sf /proc/self/mounts /etc/mtab

systemctl enable dhcpcd.service

systemctl start dhcpcd.service

dispatch-conf

mkdir /mnt/gentoo

mount /dev/sdc1 /mnt/gentoo

cd /mnt/gentoo

links https://www.gentoo.org/downloads/mirrors/

Move to the releases/amd64/autobuilds/ directory

tar xpvf stage3-*.tar.bz2 --xattrs-include='*.*' --numeric-owner

nano -w /mnt/gentoo/etc/portage/make.conf

ABI_X86="32 64"

MAKEOPTS="-j4"

VIDEO_CARDS="amdgpu radeonsi"

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

mkdir --parents /mnt/gentoo/etc/portage/repos.conf

cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

mount --types proc /proc /mnt/gentoo/proc

mount --rbind /sys /mnt/gentoo/sys

mount --make-rslave /mnt/gentoo/sys

mount --rbind /dev /mnt/gentoo/dev

mount --make-rslave /mnt/gentoo/dev

chroot /mnt/gentoo /bin/bash

source /etc/profile

export PS1="(chroot) ${PS1}"

emerge-webrsync

emerge --sync

eselect profile list

eselect profile set 

emerge --ask --update --deep --newuse @world

blkid

nano -w /etc/fstab

UUID=5a2f652b-415b-40d5-9c85-000586f46255       /               ext4            rw,relatime     0 1

lspci | grep -i VGA

For ease of installation, it is recommended to choose "AMD GPU" as a module (M)
When using AMDGPU, it is recommended to unset the ATI Radeon option so that the radeon module is not built.

emerge --ask sys-kernel/gentoo-sources

ls -l /usr/src/linux

emerge --ask sys-kernel/genkernel-next

emerge --ask sys-kernel/linux-firmware

genkernel --menuconfig all

Gentoo Linux --->

        Support for init systems, system and service managers --->
                [*]Openrc 
                
                [*] systemd
                
Graphics support  --->

<M> AMD GPU

Device Drivers  --->

    Generic Driver Options  --->
    
        Firmware loader --->
        
          -*- Firmware loading facility
          
          (amdgpu/fiji_ce.bin amdgpu/fiji_mc.bin amdgpu/fiji_me.bin amdgpu/fiji_mec2.bin amdgpu/fiji_mec.bin amdgpu/fiji_pfp.bin amdgpu/fiji_rlc.bin amdgpu/fiji_sdma1.bin amdgpu/fiji_sdma.bin amdgpu/fiji_smc.bin amdgpu/fiji_uvd.bin amdgpu/fiji_vce.bin) 
          
          Build named firmware blobs into the kernel
          (/lib/firmware) Firmware blobs root directory
ln -sf /proc/self/mounts /etc/mtab

emerge --ask app-portage/gentoolkit

lspci | grep -i audio

euse -E alsa networkmanager

After setting this be sure to update the system so the changes take effect:

emerge --ask --changed-use --deep @world

emerge --ask media-sound/alsa-utils net-misc/networkmanager net-misc/dhcpc sys-libs/gpm www-client/links app-misc/screen

systemctl enable NetworkManager

systemctl start dhcpcd.service

USE="ffmpeg" emerge -q media-plugins/alsa-plugins

USE="a52 dts" emerge -q media-video/mplayer

passwd

emerge --ask sys-boot/grub:2

nano -w /etc/default/grub

# Append parameters to the linux kernel command line

GRUB_CMDLINE_LINUX="init=/lib/systemd/systemd"

grub-install /dev/sdc

grub-mkconfig -o /boot/grub/grub.cfg

exit

cd

umount -l /mnt/gentoo/dev{/shm,/pts,}

umount -R /mnt/gentoo

reboot

systemctl start gpm

useradd -m -G users,wheel,audio -s /bin/bash lopov

passwd lopov

rm /stage3-*.tar.*

localectl set-locale LANG=en_CA.UTF-8
