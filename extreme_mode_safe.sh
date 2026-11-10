#!/system/bin/sh
# ==============================================================================
# extreme_mode_safe.sh (v3) — Maximum Safe RAM + 100% Termux Permissions
# Target: OnePlus 13R (CPH2691) | OxygenOS 16 | Snapdragon 8 Gen 3 | 12 GB RAM
# Execution: Run inside aShell (Shizuku) or ADB shell:
#   sh /storage/emulated/0/extreme_mode_safe.sh
# ==============================================================================

echo "==================================================================";
echo " [Termux Extreme Mode v3] Safe OxygenOS 16 Tuning & Full Perms    ";
echo "==================================================================";

echo "[1/7] Locking device_config sync & disabling Phantom Process Killer...";
/system/bin/device_config set_sync_disabled_for_tests persistent >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global settings_enable_monitor_phantom_procs false >/dev/null 2>&1;

echo "[2/7] Enabling Cached Apps Freezer + Safe LRU Cap (8 cached procs)...";
# CRITICAL: use_freezer must stay true on Android 14/15/16 to avoid watchdog reboot.
/system/bin/device_config put activity_manager_native_boot use_freezer true >/dev/null 2>&1;
settings put global cached_apps_freezer enabled >/dev/null 2>&1;

# v3 SAFE SWEET SPOT: Instead of 0 (which breaks Gallery->Video handoffs) or
# null/32 (which wastes ~2 GB RAM on cached apps), cap cached processes at 8
# and retain content providers for 20s so multi-app handoffs never fail!
/system/bin/device_config put activity_manager max_cached_processes 8 >/dev/null 2>&1;
/system/bin/device_config put activity_manager cur_max_cached_processes 8 >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_empty_time_millis 300000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager content_provider_retain_time 20000 >/dev/null 2>&1;

# Disable OxygenOS AI App Preloading (stops OxygenOS from silently pre-launching FB/GDrive)
settings put system oplus_app_preload_switch 0 >/dev/null 2>&1;
settings put global oplus_app_preload_switch 0 >/dev/null 2>&1;
settings put global activity_starts_logging_enabled 0 >/dev/null 2>&1;
cmd dropbox set-rate-limit 2000 >/dev/null 2>&1;

echo "[3/7] Granting ALL Possible Permissions & AppOps to Termux, Termux:X11, Termux:API...";
for tpkg in com.termux com.termux.x11 com.termux.api com.termux.widget com.termux.boot com.termux.styling; do
    if pm list packages "$tpkg" 2>/dev/null | grep -q "^package:$tpkg$"; then
        echo " -> Elevating permissions for: $tpkg";
        # 1. Doze Whitelist & Standby Bucket Active
        dumpsys deviceidle whitelist +"$tpkg" >/dev/null 2>&1;
        cmd deviceidle tempwhitelist -d 86400000 "$tpkg" >/dev/null 2>&1;
        am set-standby-bucket "$tpkg" active >/dev/null 2>&1;
        am set-inactive "$tpkg" false >/dev/null 2>&1;

        # 2. Grant every declared runtime & special permission in package manifest
        for perm in $(dumpsys package "$tpkg" 2>/dev/null | awk '/requested permissions:/,/install permissions:/' | grep -E 'android\.permission\.|com\.termux\.permission\.' | tr -d ' :'); do
            pm grant "$tpkg" "$perm" >/dev/null 2>&1;
        done;

        # 3. Explicitly grant Special / Privileged permissions (used by Termux & Termux:API)
        for s_perm in \
            android.permission.WRITE_SECURE_SETTINGS \
            android.permission.DUMP \
            android.permission.PACKAGE_USAGE_STATS \
            android.permission.READ_LOGS \
            android.permission.SET_VOLUME_KEY_LONG_PRESS_LISTENER \
            android.permission.INTERACT_ACROSS_USERS \
            android.permission.INTERACT_ACROSS_USERS_FULL; do
            pm grant "$tpkg" "$s_perm" >/dev/null 2>&1;
        done;

        # 4. Unlock all critical AppOps for unrestricted execution, X11 display, storage & API
        for op in \
            MANAGE_EXTERNAL_STORAGE \
            READ_EXTERNAL_STORAGE \
            WRITE_EXTERNAL_STORAGE \
            NO_ISOLATED_STORAGE \
            LEGACY_STORAGE \
            SYSTEM_ALERT_WINDOW \
            WRITE_SETTINGS \
            REQUEST_INSTALL_PACKAGES \
            RUN_IN_BACKGROUND \
            RUN_ANY_IN_BACKGROUND \
            START_FOREGROUND \
            INSTANT_APP_START_FOREGROUND \
            WAKE_LOCK \
            TURN_SCREEN_ON \
            PROJECT_MEDIA \
            POST_NOTIFICATIONS \
            SCHEDULE_EXACT_ALARM \
            USE_EXACT_ALARM \
            GET_USAGE_STATS \
            LOADER_USAGE_STATS \
            USAGE_STATS \
            REQUEST_IGNORE_BATTERY_OPTIMIZATIONS \
            ACCESS_NOTIFICATIONS \
            PICTURE_IN_PICTURE \
            RECORD_AUDIO \
            CAMERA \
            FINE_LOCATION \
            COARSE_LOCATION \
            MONITOR_LOCATION \
            MONITOR_HIGH_POWER_LOCATION; do
            cmd appops set "$tpkg" "$op" allow >/dev/null 2>&1;
        done;
        # Prevent Android from ever auto-revoking Termux permissions
        cmd appops set "$tpkg" AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore >/dev/null 2>&1;
    fi;
done;

echo "[4/7] Locking Down Google Drive & Facebook Background Auto-Spawn (Run ONLY When Opened)...";
# Disable GDrive background providers/sync services that trigger auto-respawn
for gdrive_comp in \
    com.google.android.apps.docs/com.google.android.apps.docs.storagebackend.StorageBackendContentProvider \
    com.google.android.apps.docs/com.google.android.apps.docs.sync.syncadapter.DocsSyncAdapterService \
    com.google.android.apps.docs/com.google.android.apps.docs.receivers.NetworkChangeReceiver \
    com.google.android.apps.docs/com.google.android.apps.docs.receivers.AccountChangeReceiver; do
    pm disable-user --user 0 "$gdrive_comp" >/dev/null 2>&1;
done;

# Surgical hard-lockdown on Facebook, Messenger, and Google Drive
for hard_pkg in \
    com.facebook.katana \
    com.facebook.orca \
    com.facebook.lite \
    com.facebook.mlite \
    com.facebook.pages.app \
    com.google.android.apps.docs; do
    if pm list packages "$hard_pkg" 2>/dev/null | grep -q "^package:$hard_pkg$"; then
        dumpsys deviceidle whitelist -"$hard_pkg" >/dev/null 2>&1;
        cmd appops set "$hard_pkg" BOOT_COMPLETED ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" START_FOREGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" INSTANT_APP_START_FOREGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" WAKE_LOCK ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" SCHEDULE_EXACT_ALARM ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" ACCOUNT_AUTHENTICATION ignore >/dev/null 2>&1;
        am set-standby-bucket "$hard_pkg" restricted >/dev/null 2>&1;
        am set-inactive "$hard_pkg" true >/dev/null 2>&1;
        cmd jobscheduler cancel "$hard_pkg" >/dev/null 2>&1;
        cmd activity make-uid-idle --user 0 "$hard_pkg" >/dev/null 2>&1;
        am force-stop "$hard_pkg" >/dev/null 2>&1;
    fi;
done;

echo "[5/7] Blocking Unopened Background Activity for All Other 3rd-Party Apps (Handoff-Safe)...";
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
    cmd jobscheduler cancel "$pkg" >/dev/null 2>&1;
done;

echo "[6/7] Restricting Heavy Non-Essential Google Apps (Leaving Core GMS/GSF/System Intact)...";
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
    cmd jobscheduler cancel "$gpkg" >/dev/null 2>&1;
done;

echo "[7/7] Verifying Active Configuration...";
echo "  max_phantom_processes : $(/system/bin/device_config get activity_manager max_phantom_processes)";
echo "  use_freezer (must=true): $(/system/bin/device_config get activity_manager_native_boot use_freezer)";
echo "  cached_apps_freezer   : $(settings get global cached_apps_freezer)";
echo "  max_cached_processes  : $(/system/bin/device_config get activity_manager max_cached_processes) (Safe cap=8)";
echo "  provider_retain_time  : $(/system/bin/device_config get activity_manager content_provider_retain_time) ms";
echo "==================================================================";
echo " [OK] Extreme Mode v3 Active — Full Termux Perms & Max Safe RAM   ";
echo "==================================================================";
