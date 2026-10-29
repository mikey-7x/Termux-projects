#!/system/bin/sh
# ==============================================================================
# xs7_ramclear.sh — Ultra-Aggressive Android 15/16 RAM, Cache & Background Purge
# Target: OnePlus 13R (CPH2691) | OxygenOS 16 | Snapdragon 8 Gen 3 | 12 GB RAM
# Execution: Run inside aShell (Shizuku) or ADB shell:
#   sh /storage/emulated/0/xs7-ramclear.sh
# Policy: ONLY currently opened/launched apps (+ Termux) may run in background.
#         Facebook, Google Drive, WhatsApp, Opera, etc. are strictly blocked
#         from background execution whenever they are not launched.
# ==============================================================================

echo "== [1/5] PURGING ALL ANDROID APP CACHES ==";
pm trim-caches 999999999999999999 >/dev/null 2>&1;
cmd package trim-caches 999999999999999999 internal >/dev/null 2>&1;
rm -rf /storage/emulated/0/Android/data/*/cache/* 2>/dev/null;
rm -rf /storage/emulated/0/Android/data/*/code_cache/* 2>/dev/null;
rm -rf /data/local/tmp/* 2>/dev/null;

echo "== [2/5] ENFORCING ZERO-CACHED-PROCESS & ZERO-RETENTION CAPS ==";
/system/bin/device_config set_sync_disabled_for_tests persistent >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global max_phantom_processes 2147483647 >/dev/null 2>&1;
/system/bin/device_config put activity_manager_native_boot use_freezer true >/dev/null 2>&1;
settings put global cached_apps_freezer enabled >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_cached_processes 0 >/dev/null 2>&1;
/system/bin/device_config put activity_manager cur_max_cached_processes 0 >/dev/null 2>&1;
/system/bin/device_config put activity_manager cur_max_empty_processes 0 >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_empty_time_millis 0 >/dev/null 2>&1;
/system/bin/device_config put activity_manager content_provider_retain_time 0 >/dev/null 2>&1;
/system/bin/device_config put activity_manager background_settle_time 0 >/dev/null 2>&1;
/system/bin/device_config put activity_manager bg_auto_restricted_bucket_on_bg_restricted true >/dev/null 2>&1;

echo "== [3/5] DISABLING AI, META, GDRIVE PROVIDER & OPLUS TELEMETRY DAEMONS ==";
for sys_pkg in \
    com.google.android.aicore \
    com.facebook.services \
    com.facebook.system \
    com.facebook.appmanager \
    com.heytap.cloud \
    com.heytap.mcs \
    com.heytap.accessory \
    com.heytap.habit.analysis \
    com.oplus.stdid \
    com.oplus.logkit \
    com.oplus.crashbox \
    com.oplus.statistics.rom \
    com.oplus.lfeh \
    com.coloros.activation; do
    pm disable-user --user 0 "$sys_pkg" >/dev/null 2>&1;
    am force-stop "$sys_pkg" >/dev/null 2>&1;
done;
# Stop Android File Picker / SyncManager from auto-spawning Google Drive in background
pm disable-user --user 0 com.google.android.apps.docs/com.google.android.apps.docs.storagebackend.StorageBackendContentProvider >/dev/null 2>&1;
pm disable-user --user 0 com.google.android.apps.docs/com.google.android.apps.docs.sync.syncadapter.DocsSyncAdapterService >/dev/null 2>&1;

echo "== [4/5] BLOCKING UNLAUNCHED BACKGROUND ACTIVITY FOR ALL APPS (INCLUDING WHATSAPP, FB, GDRIVE) ==";
for keep_pkg in com.termux com.termux.x11 com.termux.api; do
    dumpsys deviceidle whitelist +"$keep_pkg" >/dev/null 2>&1;
    cmd appops set "$keep_pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1;
    cmd appops set "$keep_pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1;
    cmd appops set "$keep_pkg" WAKE_LOCK allow >/dev/null 2>&1;
done;

for pkg in $(pm list packages -3 2>/dev/null | cut -d: -f2); do
    case "$pkg" in
        com.termux*|in.sunilpaulmathew.ashell*|moe.shizuku.privileged.api*)
            continue
            ;;
    esac;
    dumpsys deviceidle whitelist -"$pkg" >/dev/null 2>&1;
    cmd appops set "$pkg" BOOT_COMPLETED ignore >/dev/null 2>&1;
    cmd appops set "$pkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd appops set "$pkg" WAKE_LOCK ignore >/dev/null 2>&1;
    cmd appops set "$pkg" START_FOREGROUND ignore >/dev/null 2>&1;
    cmd jobscheduler cancel "$pkg" >/dev/null 2>&1;
    am set-standby-bucket "$pkg" restricted >/dev/null 2>&1;
    am set-inactive "$pkg" true >/dev/null 2>&1;
    am make-uid-idle "$pkg" >/dev/null 2>&1;
    am force-stop "$pkg" >/dev/null 2>&1;
done;

for gpkg in \
    com.google.android.apps.docs \
    com.google.android.apps.bard \
    com.google.android.youtube \
    com.google.android.apps.photos \
    com.google.android.apps.maps \
    com.android.chrome \
    com.google.android.videos \
    com.google.android.music \
    com.google.android.apps.tachyon; do
    dumpsys deviceidle whitelist -"$gpkg" >/dev/null 2>&1;
    cmd appops set "$gpkg" BOOT_COMPLETED ignore >/dev/null 2>&1;
    cmd appops set "$gpkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd appops set "$gpkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd appops set "$gpkg" WAKE_LOCK ignore >/dev/null 2>&1;
    cmd appops set "$gpkg" START_FOREGROUND ignore >/dev/null 2>&1;
    cmd jobscheduler cancel "$gpkg" >/dev/null 2>&1;
    am set-standby-bucket "$gpkg" restricted >/dev/null 2>&1;
    am set-inactive "$gpkg" true >/dev/null 2>&1;
    am make-uid-idle "$gpkg" >/dev/null 2>&1;
    am force-stop "$gpkg" >/dev/null 2>&1;
done;

echo "== [5/5] EVICTING CACHED PROCESSES & GPU BUFFERS ==";
am kill-all >/dev/null 2>&1;
am send-trim-memory com.android.systemui RUNNING_CRITICAL >/dev/null 2>&1;
am send-trim-memory com.android.launcher COMPLETE >/dev/null 2>&1;

echo "== FREE RAM AFTER ULTRA PURGE ==";
grep -E '^(MemTotal|MemFree|MemAvailable|SwapFree):' /proc/meminfo;
echo "== FREE STORAGE AFTER APP CACHE PURGE ==";
df -h /data;
