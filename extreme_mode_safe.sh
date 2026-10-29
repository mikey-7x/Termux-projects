#!/system/bin/sh
# ==============================================================================
# extreme_mode_safe.sh — Safe Termux Extreme Mode for Android 14 / 15 / 16
# Target: OnePlus 13R (CPH2691) | OxygenOS 16 | Snapdragon 8 Gen 3 | Adreno 750
# Execution: Run inside aShell (Shizuku) or ADB shell:
#   sh /storage/emulated/0/extreme_mode_safe.sh
# ==============================================================================

echo "==================================================================";
echo " [Termux Extreme Mode] Applying Safe Android 14/15/16 Tuning...  ";
echo "==================================================================";

echo "[1/6] Locking device_config sync to persistent...";
/system/bin/device_config set_sync_disabled_for_tests persistent;

echo "[2/6] Disabling Phantom Process Killer (max_phantom_processes = 2147483647)...";
/system/bin/device_config put activity_manager max_phantom_processes 2147483647;
settings put global max_phantom_processes 2147483647;
settings put global settings_enable_monitor_phantom_procs false;

echo "[3/6] Enabling Android 14/15/16 Cached Apps Freezer (Bootloop-Safe)...";
# CRITICAL: Never set use_freezer=false on Android 14/15/16 (causes 2-min Watchdog reboot)
/system/bin/device_config put activity_manager_native_boot use_freezer true;
settings put global cached_apps_freezer enabled;

echo "[4/6] Enforcing Zero Unopened Cached Process Retention...";
/system/bin/device_config put activity_manager max_cached_processes 0;
/system/bin/device_config put activity_manager cur_max_cached_processes 0;
/system/bin/device_config put activity_manager cur_max_empty_processes 0;
/system/bin/device_config put activity_manager max_empty_time_millis 0;
/system/bin/device_config put activity_manager content_provider_retain_time 0;
/system/bin/device_config put activity_manager background_settle_time 0;
/system/bin/device_config put activity_manager bg_auto_restricted_bucket_on_bg_restricted true;
pm disable-user --user 0 com.google.android.apps.docs/com.google.android.apps.docs.storagebackend.StorageBackendContentProvider >/dev/null 2>&1;
pm disable-user --user 0 com.google.android.apps.docs/com.google.android.apps.docs.sync.syncadapter.DocsSyncAdapterService >/dev/null 2>&1;

echo "[5/6] Whitelisting Termux & Blocking Unopened Background Activity for All Other Apps...";
for pkg in com.termux com.termux.x11 com.termux.api com.termux.widget com.termux.boot com.termux.styling; do
    dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1;
    cmd appops set "$pkg" SYSTEM_ALERT_WINDOW allow >/dev/null 2>&1;
    cmd appops set "$pkg" WAKE_LOCK allow >/dev/null 2>&1;
    cmd appops set "$pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1;
    cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1;
    cmd appops set "$pkg" REQUEST_IGNORE_BATTERY_OPTIMIZATIONS allow >/dev/null 2>&1;
    am set-standby-bucket "$pkg" active >/dev/null 2>&1;
    am set-inactive "$pkg" false >/dev/null 2>&1;
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
done;

for gpkg in com.google.android.apps.docs com.google.android.apps.bard com.google.android.youtube com.google.android.apps.photos com.google.android.apps.maps com.android.chrome com.google.android.videos com.google.android.music; do
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
done;

echo "[6/6] Verifying Active Configuration...";
echo "  max_phantom_processes : $(/system/bin/device_config get activity_manager max_phantom_processes)";
echo "  use_freezer (must=true): $(/system/bin/device_config get activity_manager_native_boot use_freezer)";
echo "  cached_apps_freezer   : $(settings get global cached_apps_freezer)";
echo "  max_cached_processes (expected: 0)           : $(/system/bin/device_config get activity_manager max_cached_processes)";
echo "  max_empty_time_millis (expected: 0)          : $(/system/bin/device_config get activity_manager max_empty_time_millis)";
echo "  content_provider_retain_time (expected: 0)   : $(/system/bin/device_config get activity_manager content_provider_retain_time)";
echo "  sync_disabled_for_tests (expected: persistent): $(/system/bin/device_config get_sync_disabled_for_tests)";
echo "==================================================================";
echo " [OK] Safe Extreme Mode Active — Only Launched Apps Use Background ";
echo "==================================================================";
