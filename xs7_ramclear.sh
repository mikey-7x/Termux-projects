#!/system/bin/sh
# =========================================================================
# Project   : mikey-7x/Termux-projects — Ultra RAM & App Cache Purge
# Script    : xs7_ramclear.sh
# Author    : mikey-7x (https://github.com/mikey-7x)
# Target    : OnePlus 13R (CPH2691) & Android 12+ Devices (via aShell/ADB)
# Purpose   : Frees up to 6.3+ GB RAM for xs-7 & alfa5 XFCE4 desktop.
#             Hard-blocks Facebook, Instagram, Google Drive, Opera, TubeMate,
#             and all other background RAM hogs while preserving WhatsApp
#             notifications, Gemini, Termux, Termux:X11, and Shizuku.
# Execution : sh /storage/emulated/0/xs7-ramclear.sh
# =========================================================================

echo "== [1/4] PURGING ALL ANDROID APP CACHES ==";
pm trim-caches 999999999999999999 >/dev/null 2>&1;
cmd package trim-caches 999999999999999999 internal >/dev/null 2>&1;
rm -rf /storage/emulated/0/Android/data/*/cache/* 2>/dev/null;
rm -rf /storage/emulated/0/Android/data/*/code_cache/* 2>/dev/null;
rm -rf /data/local/tmp/* 2>/dev/null;

echo "== [2/4] DISABLING AI, META & OPLUS TELEMETRY DAEMONS ==";
for sys_pkg in com.google.android.aicore com.facebook.services com.facebook.system com.facebook.appmanager com.heytap.cloud com.heytap.mcs com.heytap.accessory com.heytap.habit.analysis com.oplus.stdid com.oplus.logkit com.oplus.crashbox com.oplus.statistics.rom com.oplus.lfeh com.coloros.activation; do
  pm disable-user --user 0 "$sys_pkg" >/dev/null 2>&1;
  am force-stop "$sys_pkg" >/dev/null 2>&1;
done;

echo "== [3/4] PROTECTING WHATSAPP & GEMINI, HARD-LOCKING FACEBOOK/DRIVE/OPERA/TUBEMATE ==";
for keep_pkg in com.whatsapp com.whatsapp.w4b com.google.android.apps.bard com.google.android.googlequicksearchbox com.google.android.tts; do
  cmd appops set "$keep_pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1;
  cmd appops set "$keep_pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1;
  cmd appops set "$keep_pkg" WAKE_LOCK allow >/dev/null 2>&1;
done;

for pkg in $(pm list packages -3 2>/dev/null | cut -d: -f2); do
  case "$pkg" in
    com.termux*|in.sunilpaulmathew.ashell*|moe.shizuku.privileged.api*|com.whatsapp*|com.google.android.apps.bard*) continue ;;
  esac;
  cmd appops set "$pkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
  cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
  cmd appops set "$pkg" WAKE_LOCK ignore >/dev/null 2>&1;
  cmd appops set "$pkg" START_FOREGROUND ignore >/dev/null 2>&1;
  am set-standby-bucket "$pkg" restricted >/dev/null 2>&1;
  am force-stop "$pkg" >/dev/null 2>&1;
done;

for gpkg in com.google.android.apps.docs com.google.android.youtube com.google.android.apps.photos com.google.android.apps.maps com.android.chrome com.google.android.videos com.google.android.music; do
  cmd appops set "$gpkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
  cmd appops set "$gpkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
  cmd appops set "$gpkg" WAKE_LOCK ignore >/dev/null 2>&1;
  cmd appops set "$gpkg" START_FOREGROUND ignore >/dev/null 2>&1;
  am set-standby-bucket "$gpkg" restricted >/dev/null 2>&1;
  am force-stop "$gpkg" >/dev/null 2>&1;
done;

/system/bin/device_config set_sync_disabled_for_tests persistent >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global max_phantom_processes 2147483647 >/dev/null 2>&1;

echo "== [4/4] EVICTING CACHED PROCESSES & GPU BUFFERS ==";
am kill-all >/dev/null 2>&1;
am send-trim-memory com.android.systemui RUNNING_CRITICAL >/dev/null 2>&1;
am send-trim-memory com.android.launcher COMPLETE >/dev/null 2>&1;

echo "== FREE RAM AFTER ULTRA PURGE ==";
grep -E '^(MemTotal|MemFree|MemAvailable|SwapFree):' /proc/meminfo;
echo "== FREE STORAGE AFTER APP CACHE PURGE ==";
df -h /data;
