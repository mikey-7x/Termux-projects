# Termux Projects

A collection of practical and powerful Termux-based projects to extend your Android capabilities using Linux distributions, GUIs, automation scripts, and more!

---

## **🔥[Project-1]🔥**
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

- **Step 1: Install Required Packages**

**In Termux:**

```
termux-setup-storage
pkg update && pkg upgrade -y
pkg install wget -y
pkg install git -y
pkg install tur-repo -y
pkg install x11-repo -y
pkg install termux-x11-nightly -y
pkg install pulseaudio -y
pkg install curl -y
```

**In your Linux distribution (Ubuntu, Kali, etc.):**

```
sudo apt update && sudo apt install -y xfce4 dbus-x11 x11-xserver-utils
```

- **Step 2: Setup the termux**

Run below command in termux and remove "#" from "#allow-external-apps = true" line in the script 

```
nano ~/.termux/termux.properties
```

- **Step-3: Download the script manually:**

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

- **Step 4: Make the Script Executable**

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

**💥New:**
I added a new script namely "pd2sd.sh" which access external sd card in your linux 

simply copy your sd card path and replace this path with "/storage/67FE-7DD2:"in below line of the script

--bind /storage/67FE-7DD2:/mnt/sdcard_ext \

**Note🦞that:**
In edit the script for putting your login id, make sure add original login id (like "proot-distro login ubuntu") not a alias and then add your user id.

In all my script the "pd2sd.sh" is is well designed and worked well for proot-distro's distributions 💯.

The first script "p1.sh" is directly work with alias or your any login id.

---

## **🔥[Project-2]🔥**
**Access internal storage in any linux distributions in the termux on android phone**

---

**step-1:** make short cut of your login id in the termux 

```
nano ~/.bashrc
```
add:
```
alias mikey="udroid login jammy:xfce4 su mikey"
if [ ! -d ~/storage ]; then
    mkdir -p ~/storage
    ln -s /storage/emulated/0 ~/storage/shared
    ln -s /storage/emulated/0/Download ~/storage/downloads
    ln -s /storage/emulated/0/DCIM ~/storage/dcim
    ln -s /storage/emulated/0/Movies ~/storage/movies
    ln -s /storage/emulated/0/Music ~/storage/music
    ln -s /storage/emulated/0/Pictures ~/storage/pictures
else
    [ ! -e ~/storage/shared ] && ln -s /storage/emulated/0 ~/storage/shared
    [ ! -e ~/storage/downloads ] && ln -s /storage/emulated/0/Download ~/storage/downloads
    [ ! -e ~/storage/dcim ] && ln -s /storage/emulated/0/DCIM ~/storage/dcim
    [ ! -e ~/storage/movies ] && ln -s /storage/emulated/0/Movies ~/storage/movies
    [ ! -e ~/storage/music ] && ln -s /storage/emulated/0/Music ~/storage/music
    [ ! -e ~/storage/pictures ] && ln -s /storage/emulated/0/Pictures ~/storage/pictures
fi
cd /home/mikey
```
**edit:**

1)in first line (alias mikey="udroid login jammy:xfce4 su mikey"),

🔗"mikey" after alias text is variable you can change it which can be used to login your distribution 

🔗replace "udroid login jammy:xfce4" with your root login id

🔗 replace "mikey" in "su mikey" with your user login id

2)in the last line (cd /home/mikey),

🔗 replace "/home/mikey" with your default path for your user login id

**step-2:** press "ctrl+x" & "y" and "Enter"

**step-3:** run this in termux 
```
source ~/.bashrc
```
**step-4:** run in termux 

**(only for Ubuntu installed through udroid, this path is different for different linux distributions)**

```
nano /data/data/com.termux/files/usr/var/lib/udroid/installed-filesystems/udroid-jammy-xfce4/udroid_proot_mounts
```
add this:
```
storage/emulated/0:/storage/emulated/0
/sdcard:/sdcard
/data/data/com.termux/files/home:/home/mikey/
```
then save it using press "ctrl+x" & "y" and "Enter"

**Give execution permission:**

```
chmod 644 /data/data/com.termux/files/usr/var/lib/udroid/installed-filesystems/udroid-jammy-xfce4/udroid_proot_mounts
```

## **📜License**

This project is licensed under the 
[MIT License](LICENSE).
You are free to use, modify, and distribute it with proper attribution.

---

## **📜Credits**

Developed by **[mikey-7x](https://github.com/mikey-7x)** 🚀🔥  

Thanks to the developers of Termux, Termux-X11, PulseAudio, XFCE4, UDroid, and the open-source Linux community

---
