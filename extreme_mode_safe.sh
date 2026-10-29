#!/system/bin/sh
# =========================================================================
# Project   : mikey-7x/Termux-projects — Termux Extreme Mode (Safe Edition)
# Script    : extreme_mode_safe.sh
# Author    : mikey-7x (https://github.com/mikey-7x)
# Target    : Android 12+ / OxygenOS 15 & 16 (Tested on OnePlus 13R CPH2691)
# Execution : Run inside aShell (Shizuku) or via PC ADB:
#             sh /storage/emulated/0/extreme_mode_safe.sh
# =========================================================================

echo "==========================================================";
echo "  Termux Extreme Mode (Safe Edition) — by mikey-7x        ";
echo "  Signal 9 PPK Fix + Kernel Freezer Recovery + Permissions";
echo "==========================================================";

echo "[1/5] Enabling Android Cached-Apps Freezer (Prevents Background RAM Drain)...";
/system/bin/device_config put activity_manager_native_boot use_freezer true;
settings put global cached_apps_freezer enabled;

echo "[2/5] Disabling Phantom Process Killer (PPK) Persistently...";
/system/bin/device_config set_sync_disabled_for_tests persistent;
/system/bin/device_config put activity_manager max_phantom_processes 2147483647;
settings put global max_phantom_processes 2147483647;

echo "[3/5] Locking Developer Options & ADB Channel On...";
settings put global developer_options 1;
settings put global adb_enabled 1;

echo "[4/5] Whitelisting Termux Ecosystem from Doze & Battery Throttling...";
for pkg in com.termux com.termux.x11 com.termux.api; do
  if pm list packages "$pkg" 2>/dev/null | grep -q "$pkg"; then
    dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1;
    echo "  -> Whitelisted from Doze: $pkg";
  fi;
done;

echo "[5/5] Granting Full Non-Root AppOps Permissions to Termux Ecosystem...";
for pkg in com.termux com.termux.x11 com.termux.api; do
  if pm list packages "$pkg" 2>/dev/null | grep -q "$pkg"; then
    cmd appops set "$pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1;
    cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1;
    cmd appops set "$pkg" WAKE_LOCK allow >/dev/null 2>&1;
    cmd appops set "$pkg" SYSTEM_ALERT_WINDOW allow >/dev/null 2>&1;
    cmd appops set "$pkg" MANAGE_EXTERNAL_STORAGE allow >/dev/null 2>&1;
    am set-inactive "$pkg" false >/dev/null 2>&1;
    echo "  -> Granted background, wake-lock, overlay & storage ops: $pkg";
  fi;
done;

echo "";
echo "==================== VERIFICATION ========================";
echo "  max_phantom_processes (device_config) : $(/system/bin/device_config get activity_manager max_phantom_processes)";
echo "  max_phantom_processes (settings)      : $(settings get global max_phantom_processes)";
echo "  use_freezer (expected: true)          : $(/system/bin/device_config get activity_manager_native_boot use_freezer)";
echo "  cached_apps_freezer (expected: enabled): $(settings get global cached_apps_freezer)";
echo "  developer_options (expected: 1)       : $(settings get global developer_options)";
echo "  adb_enabled (expected: 1)             : $(settings get global adb_enabled)";
echo "  Doze Whitelist                        :";
dumpsys deviceidle whitelist | grep termux | sed 's/^/    /';
echo "==========================================================";
echo "[*] Done! Reboot once if you changed use_freezer from false to true.";
