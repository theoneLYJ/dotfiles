#!/bin/bash
source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname "$(realpath "$0")")..."
    exit 1
fi

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]
    then
    echo -e "\033[0;32m[PACMAN]\033[0m: adding extra spice to pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    #if [ $(grep -w "^\[xero_hypr\]" /etc/pacman.conf | wc -l) -eq 0 ] && [ $(grep "https://repos.xerolinux.xyz/xero_hypr/x86_64/" /etc/pacman.conf | wc -l) -eq 0 ]
    #    then
    #    echo "adding [xero_hypr] repo to pacman..."
    #    echo -e "\n[xero_hypr]\nSigLevel = Required DatabaseOptional\nServer = https://repos.xerolinux.xyz/xero_hypr/x86_64/\n\n" | sudo tee -a /etc/pacman.conf
    #fi
    sudo pacman -Syyu
    sudo pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m: pacman is already configured..."
fi


# dolphin
if pkg_installed dolphin && pkg_installed xdg-utils
    then

    xdg-mime default org.kde.dolphin.desktop inode/directory
    echo "setting" `xdg-mime query default "inode/directory"` "as default file explorer..."

else
    echo "WARNING: dolphin is not installed..."
fi


# sddm
./Source/arcs/Sddm_SugarCandy.tar.gz
if pkg_installed sddm
    then

    if [ ! -d /etc/sddm.conf.d ] ; then
        sudo mkdir -p /etc/sddm.conf.d
    fi

    if [ ! -f /etc/sddm.conf.d/kde_settings.t2.bkp ] ; then
        echo "configuring sddm..."
        sudo tar -xzf ${CloneDir}/Source/arcs/Sddm_SugarCandy.tar.gz -C /usr/share/sddm/themes/
        sudo touch /etc/sddm.conf.d/kde_settings.conf
        sudo cp /etc/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.t2.bkp
        sudo cp /usr/share/sddm/themes/corners/kde_settings.conf /etc/sddm.conf.d/
    else
        echo "sddm is already configured..."
    fi

    if [ ! -f /usr/share/sddm/faces/${USER}.face.icon ] && [ -f ${CloneDir}/Source/misc/${USER}.face.icon ] ; then
        sudo cp ${CloneDir}/Source/misc/${USER}.face.icon /usr/share/sddm/faces/
        echo "avatar set for ${USER}..."
    fi

else
    echo "WARNING: sddm is not installed..."
fi
