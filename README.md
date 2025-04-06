# Termux Projects

A collection of practical and powerful Termux-based projects to extend your Android capabilities using Linux distributions, GUIs, automation scripts, and more!


---

## **Project-1: Run Any Linux Distribution with XFCE4 in Termux-X11 GUI (with Working Sound)**

This project lets you run a full desktop Linux environment (XFCE4) inside Termux on Android with GUI and working audio using Termux-X11.


---

## **Quick One-Liner to Download and Execute:**

curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh && chmod +x p1.sh && nano p1.sh

After editing the script (see Step 2 below), run:

./p1.sh


---

## **Step-by-Step Manual Setup**

**Step 1: Install Required Packages**

**In Termux:**

pkg update
pkg install x11-repo
pkg install termux-x11-nightly
pkg install pulseaudio

**In your Linux distribution (Ubuntu, Kali, etc.):**

apt update && apt install -y xfce4 dbus-x11 x11-xserver-utils


---

**Step 2: Download and Edit the Script**

**Download the script manually:**

wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh

Edit the script:

nano p1.sh

Replace the following lines:

udroid login jammy:xfce4 << 'EOF'
su - yogesh -c 'export

**With:**

[your_login_command_here] << 'EOF'
su - [your_username_here] -c 'export

**To run as root, simply remove the line that starts with su -.**


---

**Step 3: Make the Script Executable**

chmod +x p1.sh


---

**Step 4: Run the Script**

./p1.sh


---

**Important Notes**

In a separate Termux session, run:

termux-x11 :0

Then start PulseAudio in Termux:

pulseaudio --start


---

## **📜License**

This project is licensed under the MIT License.
You are free to use, modify, and distribute it with proper attribution.


---

## **📜Credits**

Developed by **[mikey-7x](https://github.com/mikey-7x)** 🚀🔥  

Thanks to the developers of Termux, Termux-X11, PulseAudio, XFCE4, UDroid, and the open-source Linux community

---
