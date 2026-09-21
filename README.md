# 🐧 Termux Projects

> A collection of practical, field-tested Termux utilities for Android — full desktop
> environments with working audio, Android↔Linux storage bridging, safe process
> control, and a device-level **Extreme Mode** that hands Termux & Termux-X11 every
> permission Android allows without root.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%2010%2B-blue.svg)]()
[![No root required](https://img.shields.io/badge/root-not%20required-brightgreen.svg)]()

**Maintainer:** [mikey-7x](https://github.com/mikey-7x) ·
**Repository:** [mikey-7x/Termux-projects](https://github.com/mikey-7x/Termux-projects)

---

## 📑 Contents

| # | Section | What it does |
|---|---------|--------------|
| 1 | [Project 1 — XFCE4 desktop](#-project-1) | Any Linux distro (udroid/proot) with XFCE4 GUI **and working sound** in Termux-X11 |
| 2 | [Project 2 — Storage bridge](#-project-2) | Full Android internal storage access from inside any distro |
| 3 | [Process kill utilities](#-process-kill-utilities) | Safe/hard ways to kill all proot processes without breaking Termux |
| 4 | [Termux Extreme Mode](#-termux-extreme-mode-signal-9--phantom-process-fix) | Disables PPK, freezer, doze — grants every grantable permission (OnePlus 13R verified) |
| 5 | [Arch Linux mirrors](#-working-archlinux-mirrors-in-termux) | Working pacman mirrorlist for proot Arch |
| 6 | [Project 3 — Void Linux desktop](#-project-3-void-linux-desktop-on-android) | Ultra-light Void + XFCE + Falkon + audio |
| 7 | [License & credits](#-license--credits) | MIT |

---

## 🔥 Project 1

### Run Any Linux Distribution with XFCE4 in Termux-X11 GUI (with Working Sound)

This project lets you run a full desktop Linux environment (XFCE4) inside Termux on
Android with GUI and working audio using Termux-X11.

---

### Quick One-Liner to Download and Execute

```bash
curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh && chmod +x p1.sh && nano p1.sh
```

After editing the script (see Step 2 below), run:

```bash
./p1.sh
```

---

### Step-by-Step Manual Setup

**Step 1 — Install required packages**

*In Termux:*

```bash
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

*In your Linux distribution (Ubuntu, Kali, etc.):*

```bash
apt update -y
apt upgrade -y
apt install sudo nano adduser -y
```

```bash
adduser your_name
```

then it will ask for a password — type it.

```bash
nano /etc/sudoers
```

then find `root ALL=(ALL:ALL) ALL` and BELOW IT TYPE:

```
YOUR_NAME ALL=(ALL:ALL) ALL
```

Ctrl+X → Y → Enter. Then switch to your user:

```bash
su - your_name
```

Run `whoami` — if it prints your user id, the user was made successfully. Then:

```bash
apt update && apt install -y xfce4 dbus-x11 xfce4-goodies xfce4-terminal x11-xserver-utils
```

> Most of the time `sudo` is not required as root; if needed, simply prefix `sudo`
> before the `apt` command.

> ⚠️ **Known issue:** this command often stops mid-installation on
> `elementary-xfce-icon-theme`. Remove that single package with:
>
> ```bash
> dpkg --remove --force-remove-reinstreq elementary-xfce-icon-theme
> ```

*For Arch Linux:*

```bash
sudo pacman -Syu --noconfirm xfce4 dbus xorg-xhost
```

or

```bash
sudo pacman -Syu --noconfirm
sudo pacman -S --needed xfce4 xfce4-goodies
```

**Step 2 — Prepare Termux**

Run in Termux and remove the `#` from the `#allow-external-apps = true` line in:

```bash
nano ~/.termux/termux.properties
```

**Step 3 — Download the script manually**

```bash
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/p1.sh
```

Edit the script:

```bash
nano p1.sh
```

Replace the following lines:

```
udroid login jammy:xfce4 << 'EOF'
su - yogesh -c 'export
```

**With:**

```
[your_login_command_here] << 'EOF'
su - [your_username_here] -c 'export
```

> To run as root, simply remove the `su - yogesh -c` part from the p1.sh script.

**Step 4 — Make the script executable and run it**

```bash
chmod +x p1.sh
./p1.sh
```

---

### For proot-distro distributions

**Steps 1 & 2 are the same as above.**

**🦞 Install script**

```bash
curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/pd.sh
```

**OR**

```bash
curl -O https://raw.githubusercontent.com/mikey-7x/Termux-projects/main/pd2.sh
```

**🦞 Open script**

```bash
nano pd.sh
```

**OR**

```bash
nano pd2.sh
```

Replace `ubuntu` with your linux distribution's login id in this line of the script:

```
ubuntu <<'EOL'
```

**For the pd2.sh script:** replace `proot-distro login ubuntu` with your login id,
and replace `ubuntu` with your user id in this line:

```
proot-distro login ubuntu --shared-tmp -- /bin/bash -c  'export PULSE_SERVER=127.0.0.1 && export XDG_RUNTIME_DIR=${TMPDIR} && su - ubuntu -c "env DISPLAY=:0 startxfce4"'
```

```
exit 0
```

**🦞 Give permission**

```bash
chmod +x pd.sh
```

**OR**

```bash
chmod +x pd2.sh
```

**🦞 Execute the script**

```bash
./pd.sh
```

**OR**

```bash
./pd2.sh
```

---

### For Kali-Nethunter (rootless)

All procedures are the same as above (process Steps 1, 2, 3, 4), plus these extra
steps to set up Kali-Nethunter with XFCE4 in the Termux-X11 GUI.

The `p1.sh` script works perfectly with Kali-Nethunter, **with sound**.

**🦞 In Termux run:**

```sh
nano $PREFIX/bin/nh
```

**🦞 Find the `/dev` line and, after this line, add:**

```sh
-b /data/data/com.termux/files/usr/tmp:/tmp \
```

Then press `Ctrl+X` → `Enter`.

**🦞 After everything is done, run Kali-Nethunter with GUI:**

```sh
./p1.sh
```

---

### 💥 New: external SD card access (`pd2sd.sh`)

A new script, **`pd2sd.sh`**, gives your Linux distro access to an external SD card.

Simply copy your SD card path and replace `/storage/67FE-7DD2:` with your path in
this line of the script:

```
--bind /storage/67FE-7DD2:/mnt/sdcard_ext \
```

> **Note:** when editing the script to put your login id, make sure you use the
> **original login command** (e.g. `proot-distro login ubuntu`), not an alias — and
> then add your user id.
>
> In all scripts here, `pd2sd.sh` is designed to work well with proot-distro
> distributions. The first script, `p1.sh`, works directly with an alias or any
> login id.

---

## 🔥 Project 2

### Access internal storage in any Linux distribution in Termux on Android

**Step 1:** Make a shortcut for your login id in Termux:

```bash
nano ~/.bashrc
```

add:

```bash
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
    [ ! -e ~/storage/downloads ] && ln -s /storage/emulated/0/Download ~/storage/downloads
    [ ! -e ~/storage/dcim ] && ln -s /storage/emulated/0/DCIM ~/storage/dcim
    [ ! -e ~/storage/movies ] && ln -s /storage/emulated/0/Movies ~/storage/movies
    [ ! -e ~/storage/music ] && ln -s /storage/emulated/0/Music ~/storage/music
    [ ! -e ~/storage/pictures ] && ln -s /storage/emulated/0/Pictures ~/storage/pictures
fi

[ -d /home/mikey ] && cd /home/mikey
```

*For Arch Linux:*

```bash
alias mikey='proot-distro login archlinux --user mikey'
mkdir -p ~/storage

ln -sf /data/data/com.termux/files/home/storage/shared    ~/storage/shared
ln -sf /data/data/com.termux/files/home/storage/downloads ~/storage/downloads
ln -sf /data/data/com.termux/files/home/storage/dcim      ~/storage/dcim
ln -sf /data/data/com.termux/files/home/storage/music     ~/storage/music
ln -sf /data/data/com.termux/files/home/storage/movies    ~/storage/movies
ln -sf /data/data/com.termux/files/home/storage/pictures  ~/storage/pictures
```

**Edit:**

1. In the first line
   (`alias mikey="udroid login jammy:xfce4 su mikey"` /
   `alias mikey='proot-distro login archlinux --user mikey'`):

   - 🔗 the word `mikey` after `alias` is the shortcut you type to log in — change
     it to whatever you like.
   - 🔗 replace `udroid login jammy:xfce4` or `proot-distro login archlinux` with
     your root login command.
   - 🔗 replace `mikey` in `su mikey` or `--user mikey` with your user login id.

2. In the last line (`cd /home/mikey`):
   - 🔗 replace `/home/mikey` with your default path for your user login id.

**Step 2:** press `Ctrl+X` → `Y` → `Enter`

**Step 3:** run this in Termux:

```bash
source ~/.bashrc
```

**Step 4:** run your distribution by typing the alias (from step 1) in Termux —
in my case it is:

```bash
mikey
```

**Step 5:** create the accessible storage links:

```bash
mkdir -p ~/storage

ln -sf /data/data/com.termux/files/home/storage/shared    ~/storage/shared
ln -sf /data/data/com.termux/files/home/storage/downloads ~/storage/downloads
ln -sf /data/data/com.termux/files/home/storage/dcim      ~/storage/dcim
ln -sf /data/data/com.termux/files/home/storage/music     ~/storage/music
ln -sf /data/data/com.termux/files/home/storage/movies    ~/storage/movies
ln -sf /data/data/com.termux/files/home/storage/pictures  ~/storage/pictures
```

For an even simpler setup:

```bash
rm -rf ~/storage  # remove the whole folder safely
ln -sf /data/data/com.termux/files/home/storage/shared ~/storage
```

**Now you can access all of Android's internal storage from inside your Linux
distribution in Termux.**

> **Note:** you can choose any alias for logging in — I use the same name as my
> login id (`mikey` in my case).

---

## 🔥 Process kill utilities

### Kill all Termux processes safely (no harm to other packages/files)

```bash
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/refs/heads/main/killp.sh
```

### Kill processes running inside Ubuntu

*safe:*

```bash
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/refs/heads/main/ukill.sh
```

*hard:*

```bash
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/refs/heads/main/killu.sh
```

---

## 🔥 Termux Extreme Mode — Signal 9 & Phantom Process Fix

If you run heavy Linux environments through Termux (Ubuntu, Arch, Void, …) with
Termux-X11, Android 12+ will often kill your session abruptly:

```
[Process completed (signal 9) - press Enter]
```

That is caused by four independent Android mechanisms working against you:

| Mechanism | What it does |
|-----------|--------------|
| **Phantom Process Killer (PPK)** | Android 12+ limits background child processes (default cap: 32) and kills the excess — this is the #1 cause of Signal 9 for proot |
| **Cached-apps freezer** | A cgroup-freezer system that suspends "cached" app processes |
| **Doze / Device Idle** | The battery manager throttles background work and network |
| **OOM killer** | When RAM is tight the kernel kills the largest consumer |

This guide gives a complete, **device-independent, no-root** solution using
**Shizuku** + **aShell** (on-device ADB) to disable those mechanisms and grant the
full permission set to the entire Termux ecosystem (Termux, Termux:X11, Termux:API,
Termux:GUI).

### 📱 Tested configuration

| | |
|---|---|
| **Device** | OnePlus 13R (CPH2691) |
| **OS** | OxygenOS 16.0.7.200 (Android 14 kernel) |
| **Hardware** | Snapdragon 8 Gen 3, 12 GB RAM, 256 GB ROM |

---

### 🛠️ Prerequisites

Two apps are needed to run ADB-level commands **on the device, without a PC**:

1. **Shizuku** — the bridge that grants ADB-level privileges to on-device apps.
   [Google Play](https://play.google.com/store/apps/details?id=moe.shizuku.privileged.api)
2. **aShell** — a local ADB shell driven by Shizuku.
   [F-Droid](https://f-droid.org/packages/in.sunilpaulmathew.ashell/)

> Reference: [saicharankandukuri — Termux Signal 9 fix](https://saicharankandukuri.github.io/posts/termux-signal9-fix/)

---

### 🚀 Step 1 — Pair and start Shizuku

1. **Enable Developer Options:** Settings → About device → Version → tap
   **Build number** 7 times until it says "You are now a developer."
2. **Enable Wireless debugging:** Settings → System & update → Developer options →
   toggle **Wireless debugging** on (stay connected to Wi-Fi).
3. **Pair Shizuku:** open the **Shizuku** app → "Start via Wireless debugging" →
   **Pairing** → open Developer options → **Wireless debugging** (tap the text, not
   the toggle) → **Pair device with pairing code** → enter the 6-digit code into
   the Shizuku notification.
4. **Start the service:** back in **Shizuku** → **Start**. Then tap
   **Authorised Application** and enable the permission for **aShell**.

---

### 💻 Step 2 — Run the Extreme Mode command blocks in aShell

Open **aShell** → grant Shizuku access → **Allow all the time** → paste each block
and press Enter.

> If you use a PC instead, prefix **every** command with `adb shell `.

All commands below are **system-level settings writes** — once executed, they are
stored by Android and **stay active across reboots** (see the
[persistence matrix](#-persistence-what-survives-what-doesnt)).

---

#### Block 1 — Disable Phantom Process Killer & the cached-apps freezer *(persistent)*

This removes the 32-child-process ceiling and stops the freezer from suspending
your sessions — heavy desktop environments run flawlessly after this.

```bash
/system/bin/device_config set_sync_disabled_for_tests persistent
```

```bash
/system/bin/device_config put activity_manager max_phantom_processes 2147483647
```

```bash
/system/bin/device_config put activity_manager_native_boot use_freezer false
```

```bash
settings put global max_phantom_processes 2147483647
```

**Verify:**

```bash
device_config get activity_manager max_phantom_processes
device_config get activity_manager_native_boot use_freezer
```

Expected output: `2147483647` and `false`.

> The first line (`set_sync_disabled_for_tests persistent`) is what makes the PPK
> value **sticky**: it stops Android from re-syncing device_config from its
> defaults, which is exactly what makes the setting survive reboots.

---

#### Block 2 — Keep Developer Options & ADB permanently on *(persistent)*

These persist and keep the "door open" — so even if the phone is reset to a fresh
user state or someone toggles Developer Options off, the debugging channel your
tooling relies on stays reachable:

```bash
settings put global developer_options 1
```

```bash
settings put global adb_enabled 1
```

---

#### Block 3 — Remove Termux ecosystem from Doze / battery throttling *(persistent)*

Prevents the battery manager from putting Termux apps to sleep or throttling them
while running:

```bash
dumpsys deviceidle whitelist +com.termux
```

```bash
dumpsys deviceidle whitelist +com.termux.x11
```

```bash
dumpsys deviceidle whitelist +com.termux.api
```

```bash
dumpsys deviceidle whitelist +com.termux.gui
```

The appops form of the same exemption (the backend that Settings' "Unrestricted"
battery option writes) — applied for all four packages:

```bash
for pkg in com.termux com.termux.x11 com.termux.api com.termux.gui; do
  cmd appops set $pkg IGNORE_BATTERY_OPTIMIZATIONS allow
done
```

**Verify:**

```bash
dumpsys deviceidle whitelist
```

All four `com.termux*` packages should be listed.

---

#### Block 4 — Full permission grant for the Termux ecosystem *(persistent)*

Every permission that a **non-root** ADB session can grant, applied to all four
packages in one loop:

| Permission | Effect |
|------------|--------|
| `RUN_ANY_IN_BACKGROUND` | Unrestricted background execution |
| `SYSTEM_ALERT_WINDOW` | "Display over other apps" — Termux-X11 renders correctly over Android |
| `MANAGE_EXTERNAL_STORAGE` | "All files access" — no scoped-storage interference |
| `IGNORE_BATTERY_OPTIMIZATIONS` | No battery throttling (same effect as the Settings toggle, written directly) |

```bash
for pkg in com.termux com.termux.x11 com.termux.api com.termux.gui; do
  appops set $pkg RUN_ANY_IN_BACKGROUND allow
  appops set $pkg SYSTEM_ALERT_WINDOW allow
  appops set $pkg MANAGE_EXTERNAL_STORAGE allow
  appops set $pkg IGNORE_BATTERY_OPTIMIZATIONS allow
done
```

```bash
appops set --user 0 com.termux SYSTEM_ALERT_WINDOW allow
appops set --user 0 com.termux.x11 SYSTEM_ALERT_WINDOW allow
```

**Runtime permission (notifications):**

```bash
pm grant com.termux android.permission.POST_NOTIFICATIONS
pm grant com.termux.x11 android.permission.POST_NOTIFICATIONS
pm grant com.termux.api android.permission.POST_NOTIFICATIONS
pm grant com.termux.gui android.permission.POST_NOTIFICATIONS
```

> If a `pm grant` line prints an error like "permission not declared", that build of
> the app simply doesn't declare that permission — it is safe to ignore.

**Storage inside Termux** (the user-side counterpart of `MANAGE_EXTERNAL_STORAGE`):

```bash
termux-setup-storage
```

> ⚠️ **Honest limit (no root):** permissions marked *signature* or *privileged*
> (`WRITE_SECURE_SETTINGS`, `DUMP`, `READ_LOGS`, …) **cannot** be granted by any
> non-root tool — a plain `pm grant` for them can only fail. The set above is the
> **complete grantable set**.

**Verify:**

```bash
appops get com.termux
appops get com.termux.x11
```

Look for `RUN_ANY_IN_BACKGROUND allow`, `SYSTEM_ALERT_WINDOW allow`,
`MANAGE_EXTERNAL_STORAGE allow`, `IGNORE_BATTERY_OPTIMIZATIONS allow`.

---

#### Block 5 — Temporary session hints *(NOT persistent — by design)*

These act as hints for the currently active session only and are **not** stored.
Run them whenever you want an extra nudge (harmless, but they do not survive a
reboot or an app restart):

```bash
am set-inactive com.termux false
```

```bash
am set-inactive com.termux.x11 false
```

---

### ✅ Verification

Once all blocks are run, you can launch Termux, boot your Linux container, and fire
up Termux-X11 without worrying about random Signal 9 kills:

```bash
device_config get activity_manager max_phantom_processes      # → 2147483647
device_config get activity_manager_native_boot use_freezer    # → false
settings get global developer_options                          # → 1
settings get global adb_enabled                                # → 1
dumpsys deviceidle whitelist                                   # → com.termux* listed
appops get com.termux | grep -E 'RUN_ANY_IN_BACKGROUND|SYSTEM_ALERT_WINDOW|MANAGE_EXTERNAL_STORAGE|IGNORE_BATTERY'
```

---

### 🧲 Persistence — what survives, and what doesn't

Everything written in Blocks 1–4 is stored by Android itself under
`/data/system` (device_config protobuf, Settings provider database,
`app-ops.xml`, device-idle whitelist). Consequences:

| Setting | Survives reboot | Survives turning Developer Options off | Survives app update |
|---------|:---:|:---:|:---:|
| `device_config put` (with sync disabled) | ✅ | ✅ | ✅ |
| `settings put global …` | ✅ | ✅ | ✅ |
| `appops set … allow` | ✅ | ✅ | ✅ |
| `dumpsys deviceidle whitelist …` | ✅ | ✅ | ✅ |
| `am set-inactive` (Block 5) | ❌ temporary | ❌ | ❌ |

**Why turning Developer Options off changes nothing:** Developer Options only
control the *channel* used to deliver the commands (USB/wireless debugging). The
settings themselves live in system storage and are not tied to that channel at all.
`settings put global developer_options 1` (Block 2) additionally keeps the menu
itself from being hidden again.

**The two real reset vectors:**

1. **Major OxygenOS/Android system update** — some updates re-apply AOSP
   device_config defaults. Fix: re-run **Block 1** (takes 20 seconds).
2. **Wireless-debugging pairing timeout** — Shizuku's wireless pairing idles out
   after a few hours. That only affects *running new* commands; every setting above
   keeps working the whole time. Re-pair via the Shizuku app when needed.

---

### 🧹 Removed from the previous revision (safety review)

The older revision of this section contained commands that were either fake,
pointless, or carried real side-effect risk. They are **deliberately gone**:

| Removed command | Why it was removed |
|-----------------|--------------------|
| `settings delete global activity_manager_constants` | Deletes a live system-settings entry. No PPK benefit; unknown side effects on framework behavior. |
| `settings put global settings_enable_monitor_phantom_procs false` | Not a real framework setting — it only wrote a dead key. |
| `pm grant … android.permission.WRITE_SECURE_SETTINGS` | *signature* permission — impossible without root; the command can only error. |
| `pm grant … android.permission.DUMP` | *signature* permission — same as above. |
| `pm grant … android.permission.READ_LOGS` | *signature* permission — same as above. |
| `pm grant … android.permission.PACKAGE_USAGE_STATS` | Not a runtime permission — granted only via *Settings → Special app access → Usage access*, if ever needed. |
| Legacy `pm grant … READ/WRITE_EXTERNAL_STORAGE` | Max-Sdk-capped on recent builds; replaced by `termux-setup-storage` + the `MANAGE_EXTERNAL_STORAGE` appop (Block 4). |
| Duplicated `MANAGE_EXTERNAL_STORAGE` lines | Consolidated into the Block 4 loop. |

---

## 🦞 Working Arch Linux mirrors in Termux

```bash
echo 'Server = http://mirrors.tuna.tsinghua.edu.cn/archlinuxarm/$arch/$repo' > /etc/pacman.d/mirrorlist
```

OR

```bash
nano /etc/pacman.d/mirrorlist
```

```
Server = http://mirror.archlinuxarm.org/$arch/$repo
```

---

## 🔥 Project 3

# 🐧 Void Linux Desktop on Android
### Termux • proot-distro • XFCE • X11 • Working Audio

> **Author:** mikey-7x
> **Platform:** Android (No Root)
> **Status:** Stable Desktop + Browser + Audio

---

### 📌 Overview

This project provides a **complete Linux desktop environment on Android** using:

- **Void Linux** (ultra-light, fast, systemd-free)
- **Termux + proot-distro**
- **XFCE Desktop**
- **Termux-X11 real display server**
- **PulseAudio with real Android sound output**

This is **not** VNC, not emulation, not a fake desktop — it is a real Linux system
running inside Android.

---

### ✨ Features

| Feature | Status |
|---------|--------|
| Void Linux Shell | ✅ Working |
| XFCE Desktop | ✅ Working |
| Hardware Audio | ✅ Working |
| Termux-X11 Display | ✅ Working |
| Falkon Browser + YouTube | ✅ Working |
| Package Manager (xbps) | ✅ Working |
| Non-Root Installation | ✅ Supported |
| Long Sessions Stability | ⚠️ Limited by Android memory |

---

### 🧠 Why Void Linux?

Void Linux is ideal for Android because:

- No **systemd** (avoids proot conflicts)
- Very low memory usage
- Extremely fast package manager (`xbps`)
- Minimal background services
- Perfect compatibility with Termux environments

---

### 🧰 Requirements

- Android 10+
- **Termux** from F-Droid
- **Termux-X11** app
- Minimum **4 GB RAM** recommended
- No root required

---

### 🏗 Installation

**1️⃣ Prepare Termux**

```bash
pkg update -y
pkg install -y root-repo x11-repo
pkg install -y proot-distro termux-x11 pulseaudio dbus
```

**2️⃣ Install Void Linux**

```bash
proot-distro install void
```

**3️⃣ Enter Void Linux**

```bash
proot-distro login void
```

**4️⃣ Install Desktop & Tools (inside Void)**

```bash
xbps-install -Syu

xbps-install -y \
  xfce4 xfce4-terminal \
  xorg-minimal xrandr \
  mesa-dri \
  dbus-x11 \
  noto-fonts-ttf dejavu-fonts-ttf liberation-fonts-ttf \
  fontconfig glibc-locales \
  pulseaudio pulseaudio-utils \
  falkon dillo
```

**Configure locale:**

```bash
echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales

echo 'export LANG=en_US.UTF-8' >> /etc/profile
echo 'export LC_ALL=en_US.UTF-8' >> /etc/profile
```

**Exit Void:**

```bash
exit
```

---

### 🌐 Installing & Configuring Falkon Browser (Void Linux)

> These steps are done **inside Void Linux**.

**1️⃣ Install Falkon**

```bash
xbps-install -y falkon qt5-wayland qt5-x11extras
```

(Those Qt packages prevent crashes and rendering issues.)

**2️⃣ Create a safe launcher**

Falkon cannot run as root unless its sandbox is disabled. This wrapper makes
Falkon stable on Android:

```bash
nano /usr/local/bin/falkon-safe
```

Paste:

```bash
#!/bin/sh
export QTWEBENGINE_DISABLE_SANDBOX=1
export QT_XCB_GL_INTEGRATION=none
falkon "$@"
```

Save and exit. Make executable:

```bash
chmod +x /usr/local/bin/falkon-safe
```

**3️⃣ Run Falkon**

```bash
falkon-safe
```

**🧪 Optional: Desktop menu entry**

```bash
nano /usr/share/applications/falkon-safe.desktop
```

Paste:

```ini
[Desktop Entry]
Name=Falkon (Safe)
Exec=/usr/local/bin/falkon-safe
Icon=falkon
Type=Application
Categories=Network;WebBrowser;
```

Update the menu:

```bash
update-desktop-database
```

Falkon now appears in the XFCE menu as **Falkon (Safe)**.

**🧠 Why this works:**

| Setting | Reason |
|---------|--------|
| Disable sandbox | Required because proot runs as root |
| Disable Qt GL | Prevents GPU crashes on Android |
| Qt X11 packages | Prevents blank window / crashes |

**🟢 Result:** Falkon launches reliably, YouTube works, audio works, no sandbox
crash, maximum stability on Android.

---

### 🖥 GUI + Audio startup script

Create the launcher in Termux:

```bash
wget https://raw.githubusercontent.com/mikey-7x/Termux-projects/refs/heads/main/vd.sh
chmod +x vd.sh
```

**🚀 Launch desktop**

```bash
./vd.sh
```

Then open the Termux-X11 app.

**🌐 Browsers**

- Main browser: `falkon --no-sandbox`
- Backup lightweight browser: `dillo`

**🔊 Audio architecture**

```
Void Linux → PulseAudio TCP → Termux PulseAudio → Android AAudio → Speaker
```

This gives real hardware sound inside the Linux desktop.

---

### ⚠️ Known limitation

Android may kill heavy apps with SIGKILL (signal 9) when memory is low. This is a
kernel limitation, not a configuration bug. (Pair with
[Termux Extreme Mode](#-termux-extreme-mode-signal-9--phantom-process-fix) to remove
the *non-memory* kill sources.)

---

### 🏁 Final result

You now have a real Linux desktop environment on Android with:

- GUI
- Browser
- Hardware audio
- Package manager
- Development tools

**No root. No VNC. No emulation.**

---

## 📜 License & Credits

This project is licensed under the
[MIT License](LICENSE).
You are free to use, modify, and distribute with proper attribution.

Developed by **[mikey-7x](https://github.com/mikey-7x)** 🚀🔥

Built & maintained by mikey-7x — community-grade Linux on mobile.

[Other repositories](https://github.com/mikey-7x?tab=repositories)

Thanks to the developers of Termux, Termux-X11, PulseAudio, XFCE4, UDroid, and the
open-source Linux community.
