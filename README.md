https://wiki.gentoo.org/wiki/Handbook:AMD64

https://wiki.gentoo.org/wiki/Systemd/Installing_Gnome3_from_scratch

https://wiki.gentoo.org/wiki/Handbook:Parts/Working/Portage/en

https://github.com/Pednick/archlinux

https://wiki.gentoo.org/wiki/ALSA#Hardware_detection

dispatch-conf

hdparm --user-master u --security-erase PasSWorD /dev/sda

blkdiscard /dev/sdX

tune2fs -o discard /dev/sdXY

mkfs.ext4 -E stride=128,stripe-width=128 /dev/sda1

mkdir /mnt/gentoo

mount /dev/sda1 /mnt/gentoo

cd /mnt/gentoo

https://www.gentoo.org/downloads/

Stage 3 systemd2020-03-26 349 MiB

wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20200401T214502Z/stage3-amd64-20200401T214502Z.tar.xz

tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

nano -w /mnt/gentoo/etc/portage/make.conf

ABI_X86="32 64"

MAKEOPTS="-j4"

VIDEO_CARDS="amdgpu radeonsi"

blkid

nano -w /mnt/gentoo/etc/fstab

UUID=fce2c572-f3e5-42cd-892b-e528497949cf	/         	ext4      	defaults,relatime,discard	0 1

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

mkdir --parents /mnt/gentoo/etc/portage/repos.conf

cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

mount to chroot

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

emerge --ask --update --deep --newuse @world

lspci | grep -i VGA

For ease of installation, it is recommended to choose "AMD GPU" as a module (M)
When using AMDGPU, it is recommended to unset the ATI Radeon option so that the radeon module is not built.

emerge --ask sys-kernel/gentoo-sources

emerge --ask sys-kernel/linux-firmware

emerge --ask sys-kernel/genkernel-next

genkernel --menuconfig all

genkernel all

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

user $echo amdgpu/fiji_{ce,mc,me,mec2,mec,pfp,rlc,sdma1,sdma,smc,uvd,vce}.bin
          
amdgpu/fiji_ce.bin amdgpu/fiji_mc.bin amdgpu/fiji_me.bin amdgpu/fiji_mec2.bin amdgpu/fiji_mec.bin amdgpu/fiji_pfp.bin amdgpu/fiji_rlc.bin amdgpu/fiji_sdma1.bin amdgpu/fiji_sdma.bin amdgpu/fiji_smc.bin amdgpu/fiji_uvd.bin amdgpu/fiji_vce.bin
          
          Build named firmware blobs into the kernel
          (/lib/firmware) Firmware blobs root directory

ln -sf /proc/self/mounts /etc/mtab

emerge --ask net-misc/dhcpcd

emerge --ask sys-libs/gpm www-client/links app-misc/screen

emerge --ask sys-apps/systemd

lspci | grep -i audio

emerge --ask media-sound/alsa-utils

USE="ffmpeg" emerge -q media-plugins/alsa-plugins

USE="a52 dts" emerge -q media-video/mplayer

passwd

emerge --ask sys-boot/grub:2

nano -w /etc/default/grub

# Append parameters to the linux kernel command line

GRUB_CMDLINE_LINUX="init=/lib/systemd/systemd"

grub-install /dev/sda

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

emerge --ask x11-base/xorg-server

Check startx
In order to check the x server install x11-terms/xterm and x11-terms/twm:

root #emerge --ask x11-terms/xterm x11-wm/twm
Then use the following command:

root #startx
If everything is correct, a graphic page with some terminals inside will appear. Quit by pressing Ctrl+Alt+Del and remove x11-terms/xterm and x11-terms/twm:

root #emerge --ask --depclean --verbose x11-terms/xterm x11-wm/twm

emerge --ask gnome

systemctl enable gdm.service

systemctl enable NetworkManager
