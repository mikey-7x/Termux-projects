# Termux Projects

A collection of practical and powerful Termux-based projects to extend your Android capabilities using Linux distributions, GUIs, automation scripts, and more!


---

## **Project-1: Run Any Linux Distribution with XFCE4 in Termux-X11 GUI (with Working Sound)**

This project lets you run a full desktop Linux environment (XFCE4) inside Termux on Android with GUI and working audio support using Termux-X11.


---

**Step 1: Install Necessary Packages**

In Termux:

pkg update
pkg install x11-repo
pkg install termux-x11-nightly
pkg install pulseaudio

Inside Your Linux Distribution (Ubuntu, Kali, etc.):

apt update && apt install -y xfce4 dbus-x11 x11-xserver-utils


---

**Step 2: Download and Edit the Script**

Download the script p1.sh:

Click here to download p1.sh

Or via command line:


wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh

Edit the script:

nano p1.sh

Replace the following lines:

udroid login jammy:xfce4 << 'EOF'
su - yogesh -c 'export

With:

[your_linux_login_command] << 'EOF'
su - [your_username] -c 'export

Example (for root login in proot-distro):

proot-distro login kali-large --shared-tmp << 'EOF'
export

To run as root user, simply remove the line:

su - yogesh -c 'export


---

**Step 3: Make the Script Executable**

chmod +x p1.sh


---

**Step 4: Execute the Script**

./p1.sh


---

Tips for GUI and Sound

Start GUI in a separate Termux session:


termux-x11 :0

Start audio service before launching GUI:


pulseaudio --start


---

## **📜License**

This project is licensed under the MIT License.
Feel free to use, modify, and distribute with credit.


---

## **📜Credits**

Developed and maintained by mikey-7x

XFCE4, Termux, Termux-X11, PulseAudio, proot-distro and UDroid community for open-source 

---
