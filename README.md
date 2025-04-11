# Termux Projects

A collection of practical and powerful Termux-based projects to extend your Android capabilities using Linux distributions, GUIs, automation scripts, and more!

**New:**
I added a new script namely "pd2sd.sh" which access external sd card in your linux 

simply copy your sd card path and replace this path with "/storage/67FE-7DD2:/mnt/sdcard_ext "in below line of the script

--bind /storage/67FE-7DD2:/mnt/sdcard_ext \

---

## **[Project-1]:**
**Run Any Linux Distribution with XFCE4 in Termux-X11 GUI (with Working Sound)**

This project lets you run a full desktop Linux environment (XFCE4) inside Termux on Android with GUI and working audio using Termux-X11.


---

## **Quick One-Liner to Download and Execute:**

```
curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh && chmod +x p1.sh && nano p1.sh
```

After editing the script (see Step 2 below), run:

```
./p1.sh
```

---

## **Step-by-Step Manual Setup**

**🦞Step 1: Install Required Packages**

**In Termux:**

```
pkg update
pkg upgrade
pkg install x11-repo
pkg install termux-x11-nightly
pkg install tur-repo
pkg install pulseaudio
pkg install wget
pkg install git
```

**In your Linux distribution (Ubuntu, Kali, etc.):**

```
apt update && apt install -y xfce4 dbus-x11 x11-xserver-utils
```

**🦞Step 2: Setup the termux**

Run below command in termux and remove "#" from "#allow-external-apps = true" line in the script 

```
nano ~/.termux/termux.properties
```

**🦞Step-3: Download the script manually:**

```
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh
```

Edit the script:

```
nano p1.sh
```

Replace the following lines:

udroid login jammy:xfce4 << 'EOF'
su - yogesh -c 'export

**With:**

[your_login_command_here] << 'EOF'
su - [your_username_here] -c 'export

**To run as root, simply remove the "su - yogesh -c" in p1.sh script**

**🦞Step 4: Make the Script Executable**

```
chmod +x p1.sh
```

**Run the Script**

```
./p1.sh
```
---

## **For proot-distro's distributions:**

**Step-1&2 is same and is mensioned above**

**🦞install script**
```
curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/pd.sh
```
**OR**
```
curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/pd2.sh
```

**🦞open script**
```
nano pd.sh
```
**OR**
```
nano pd2.sh
```

**🦞replace "ubuntu" from your login id of linux distribution in below line in script**

ubuntu <<'EOL'

**For pd2.sh script:**
replace "proot-distro login ubuntu" with your login id and replace "ubuntu" with your user id in below line of script👇

proot-distro login ubuntu --shared-tmp -- /bin/bash -c  'export PULSE_SERVER=127.0.0.1 && export XDG_RUNTIME_DIR=${TMPDIR} && su - ubuntu -c "env DISPLAY=:0 startxfce4"'

exit 0        

**🦞give permission**
```
chmod +x pd.sh
```
**OR**
```
chmod +x pd2.sh
```

**🦞execute script**
```
./pd.sh
```
**OR**
```
./pd2.sh
```
--- 

## **For Kali-Nethunter (rootless)**

All procedure is same as above mentioned steps (process the Step-1,2,3,4) but add some extra steps to set-up Kali-Nethunter with xfce4 in termux-x11 gui

for Kali-Nethunter "p1.sh" script is working perfectly with sound 

**🦞In termux run:**

```sh
nano $PREFIX/bin/nh
```

**🦞Find "/dev" line and after this line add below command:**

```sh
-b /data/data/com.termux/files/usr/tmp:/tmp \
```

**Then press "ctrl+x" button in keyboard then press  "enter "**

**🦞After all process run Kali-Nethunter with gui by command:**

```sh
./p1.sh
```
---

## **📜License**

This project is licensed under the 
[MIT License](LICENSE).
You are free to use, modify, and distribute it with proper attribution.

---

## **📜Credits**

Developed by **[mikey-7x](https://github.com/mikey-7x)** 🚀🔥  

Thanks to the developers of Termux, Termux-X11, PulseAudio, XFCE4, UDroid, and the open-source Linux community

---
