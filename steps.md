# Arch Linux Setup Guide

This guide will help you set up an Arch Linux system with useful tools, configurations, and development environments.

---

## 1. Update System
```bash
sudo pacman -Syu
```

---

## 2. Install Essential Packages
```bash
sudo pacman -S nano git vim neofetch
sudo pacman -S --needed base-devel git
```

---

## 3. Install Yay (AUR Helper)
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

---

## 4. Enable "ILoveCandy" in Pacman
Open the Pacman configuration file:
```bash
sudo nano /etc/pacman.conf
```
Add the following line:
```
ILoveCandy
```

Update package databases:
```bash
sudo pacman -Sy
```

---

## 5. Optimize Mirrors with Reflector
```bash
sudo pacman -S reflector
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

Refresh database:
```bash
sudo pacman -Sy
```

---

## 6. Install Java
```bash
sudo pacman -S jdk-openjdk
```

Check installed versions:
```bash
archlinux-java status
```

---

## 7. Install CPU Microcode
For **AMD**:
```bash
sudo pacman -S amd-ucode
```
For **Intel**:
```bash
sudo pacman -S intel-ucode
```

Update GRUB:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 8. Install Flatpak
```bash
sudo pacman -S flatpak
```

---

## 9. Install Common Applications
```bash
sudo pacman -S firefox libreoffice-fresh vlc gimp thunderbird kdenlive krita
sudo pacman -S vscodium
```

---

## 10. Install Flutter & Android Development Tools
```bash
yay -S flutter
yay -S android-sdk android-sdk-platform-tools android-sdk-build-tools
yay -S android-platform
```

---

## 11. Optional: Install Hyprland and Kitty
If not installed with Hyprland:
```bash
yay -S kitty
yay -S hyprland
```

---

✅ You’re now set up with a fully working Arch Linux environment for general use and development.
