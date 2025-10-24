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
apt update -y
apt upgrade -y
apt install sudo nano adduser -y
```
```
adduser your_name
```
then it will ask password type it
```
nano /etc/sudoers
```
then find 'root ALL=(ALL:ALL) ALL'
BELOW IT TYPE
```
YOUR_NAME ALL=(ALL:ALL) ALL
```
CTRL+X Y Enter
then got to your user id through 
```
su - your_name
```
run 'whoami' if it gives your_name user id successfully maked then run below commands 
```
apt update && apt install -y xfce4 dbus-x11 xfce4-terminal x11-xserver-utils
```
most time sudo not required in root user but if neede simply write sudo after 'apt' command 

many times this command stopped at mid position during installation of 'elementary-xfce-icon-theme'.so,we uninstall this perticular package through 
```
dpkg --remove --force-remove-reinstreq elementary-xfce-icon-theme
```

for Archlinux:
```
sudo pacman -Syu --noconfirm xfce4 dbus xorg-xhost
```
or
```
sudo pacman -Syu --noconfirm
sudo pacman -S --needed xfce4 xfce4-goodies
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

# Enable colored prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        PS1='\033[01;32m\u@\h:\w\$ \033[00m'
    else
        PS1='\u@\h:\w\$ '
    fi
fi

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
    [ ! -e ~/storage/downloads ] && ln -s /storage/emulated/0/Download ~/s>
    [ ! -e ~/storage/dcim ] && ln -s /storage/emulated/0/DCIM ~/storage/dc>
    [ ! -e ~/storage/movies ] && ln -s /storage/emulated/0/Movies ~/storag>
    [ ! -e ~/storage/music ] && ln -s /storage/emulated/0/Music ~/storage/>
    [ ! -e ~/storage/pictures ] && ln -s /storage/emulated/0/Pictures ~/st>
fi

[ -d /home/mikey ] && cd /home/mikey
```

**for Archlinux:**

```
alias mikey='proot-distro login archlinux --user mikey'
mkdir -p ~/storage

ln -sf /data/data/com.termux/files/home/storage/shared    ~/storage/shared
ln -sf /data/data/com.termux/files/home/storage/downloads ~/storage/downloads
ln -sf /data/data/com.termux/files/home/storage/dcim      ~/storage/dcim
ln -sf /data/data/com.termux/files/home/storage/music     ~/storage/music
ln -sf /data/data/com.termux/files/home/storage/movies    ~/storage/movies
ln -sf /data/data/com.termux/files/home/storage/pictures  ~/storage/pictures
```

**edit:**

1)in first line (alias mikey="udroid login jammy:xfce4 su mikey")/(alias mikey='proot-distro login archlinux --user mikey')

🔗"mikey" after alias text is variable you can change it which can be used to login your distribution 

🔗replace "udroid login jammy:xfce4"or"proot-distro login archlinux" with your root login id

🔗 replace "mikey" in "su mikey"or "--user mikey" with your user login id

2)in the last line (cd /home/mikey),

🔗 replace "/home/mikey" with your default path for your user login id

**step-2:** press "ctrl+x" & "y" and "Enter"

**step-3:** run this in termux 
```
source ~/.bashrc
```

**step-4:** run your distribution through typing alias in termux (which can be edited in first line of step-1) in my case it is:

```
mikey
```
**step-4:**after this create accessible file folder 

```
mkdir -p ~/storage

ln -sf /data/data/com.termux/files/home/storage/shared    ~/storage/shared
ln -sf /data/data/com.termux/files/home/storage/downloads ~/storage/downloads
ln -sf /data/data/com.termux/files/home/storage/dcim      ~/storage/dcim
ln -sf /data/data/com.termux/files/home/storage/music     ~/storage/music
ln -sf /data/data/com.termux/files/home/storage/movies    ~/storage/movies
ln -sf /data/data/com.termux/files/home/storage/pictures  ~/storage/pictures
```

then run if you want to more simple setup:

```
rm -rf ~/storage  # remove the whole folder safely
ln -sf /data/data/com.termux/files/home/storage/shared ~/storage
```
**Now we are able to access all android's internal storage in your linux distributions in the termux**

**Note:** make sure you can choose any alias for login your id but i put same alias as my login id (which is mikey for my case only) 

---
## **🔥[Kill all process of termux safely without harming your other package and directories/files]🔥**

```
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/refs/heads/main/killp.sh

```
---

## **📜License**

This project is licensed under the 
[MIT License](LICENSE).
You are free to use, modify, and distribute it with proper attribution.

---

## **📜Credits**

Developed by **[mikey-7x](https://github.com/mikey-7x)** 🚀🔥  


[other repository](https://github.com/mikey-7x?tab=repositories)


Thanks to the developers of Termux, Termux-X11, PulseAudio, XFCE4, UDroid, and the open-source Linux community

---
