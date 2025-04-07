#!/data/data/com.termux/files/usr/bin/bash

# Set Display
export DISPLAY=:0

# Start PulseAudio
pulseaudio --start --exit-idle-time=-1

# Start Termux-X11
termux-x11 :0 &

# Wait for X11 to be ready
sleep 3

# Start your linux (in my case it is U-Droid's ubuntu) with XFCE4 and execute commands inside it
udroid login jammy:xfce4 << 'EOF'
export DISPLAY=:0
export PULSE_SERVER=tcp:127.0.0.1:4713
dbus-launch --exit-with-session startxfce4
EOF
