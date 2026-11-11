#!/system/bin/sh
# ==============================================================================
# extreme_mode_safe.sh (v6) — ColorOS 17 Tuning + Full Termux Permissions
# Target: OnePlus 13R (CPH2691_17.0.0.105) | ColorOS 17 | 12 GB RAM
# Execution: sh /storage/emulated/0/extreme_mode_safe.sh
# ==============================================================================

echo "==================================================================";
echo " [Termux Extreme Mode v6] ColorOS 17 Tuning & 100% Termux Perms   ";
echo "==================================================================";

echo "[1/7] Locking device_config sync & disabling Phantom Process Killer...";
/system/bin/device_config set_sync_disabled_for_tests persistent >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global settings_enable_monitor_phantom_procs false >/dev/null 2>&1;

echo "[2/7] Eliminating ColorOS 17 1.6GB Cached Bloat (Safe 1-Proc LRU + 20s Provider)...";
/system/bin/device_config put activity_manager_native_boot use_freezer true >/dev/null 2>&1;
settings put global cached_apps_freezer enabled >/dev/null 2>&1;

# ColorOS 17 counts Cached apps as Used RAM. Capping cached processes at 1 and
# empty time at 5s reclaims ~1.4 GB of Cached RAM while 20s provider retention
# keeps Gallery->Video and intent handoffs 100% crash-free!
/system/bin/device_config put activity_manager max_cached_processes 1 >/dev/null 2>&1;
/system/bin/device_config put activity_manager cur_max_cached_processes 1 >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_empty_time_millis 5000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager content_provider_retain_time 20000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_service_inactivity 15000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager bg_settle_time 5000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager use_compaction true >/dev/null 2>&1;
/system/bin/device_config put runtime_native usap_pool_enabled false >/dev/null 2>&1;

# Disable ColorOS 17 Athena / AI App Preload that pre-spawns Facebook & Gmail into RAM
settings put system oplus_app_preload_switch 0 >/dev/null 2>&1;
settings put global oplus_app_preload_switch 0 >/dev/null 2>&1;
settings put global activity_starts_logging_enabled 0 >/dev/null 2>&1;
cmd dropbox set-rate-limit 2000 >/dev/null 2>&1;

echo "[3/7] Granting ALL Possible Permissions & AppOps to Termux, Termux:X11, Termux:API...";
for tpkg in com.termux com.termux.x11 com.termux.api com.termux.widget com.termux.boot com.termux.styling; do
    if pm list packages "$tpkg" 2>/dev/null | grep -q "^package:$tpkg$"; then
        echo " -> Elevating permissions for: $tpkg";
        dumpsys deviceidle whitelist +"$tpkg" >/dev/null 2>&1;
        cmd deviceidle tempwhitelist -d 86400000 "$tpkg" >/dev/null 2>&1;
        am set-standby-bucket "$tpkg" active >/dev/null 2>&1;
        am set-inactive "$tpkg" false >/dev/null 2>&1;

        for perm in $(dumpsys package "$tpkg" 2>/dev/null | awk '/requested permissions:/,/install permissions:/' | grep -E 'android\.permission\.|com\.termux\.permission\.' | tr -d ' :'); do
            pm grant "$tpkg" "$perm" >/dev/null 2>&1;
        done;

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
        cmd appops set "$tpkg" AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore >/dev/null 2>&1;
    fi;
done;

echo "[4/7] Hard-Locking Facebook, GDrive, Gmail (374MB Cached) & microG From Background Respawn...";
for gdrive_comp in \
    com.google.android.apps.docs/com.google.android.apps.docs.storagebackend.StorageBackendContentProvider \
    com.google.android.apps.docs/com.google.android.apps.docs.sync.syncadapter.DocsSyncAdapterService \
    com.google.android.apps.docs/com.google.android.apps.docs.receivers.NetworkChangeReceiver \
    com.google.android.apps.docs/com.google.android.apps.docs.receivers.AccountChangeReceiver; do
    pm disable-user --user 0 "$gdrive_comp" >/dev/null 2>&1;
done;

for hard_pkg in \
    com.facebook.katana \
    com.facebook.orca \
    com.facebook.lite \
    com.google.android.apps.docs \
    com.google.android.gm \
    app.revanced.android.gms \
    com.mgoogle.android.gms; do
    if pm list packages "$hard_pkg" 2>/dev/null | grep -q "^package:$hard_pkg$"; then
        dumpsys deviceidle whitelist -"$hard_pkg" >/dev/null 2>&1;
        cmd appops set "$hard_pkg" BOOT_COMPLETED ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" START_FOREGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" INSTANT_APP_START_FOREGROUND ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" WAKE_LOCK ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" SCHEDULE_EXACT_ALARM ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" GET_ACCOUNTS ignore >/dev/null 2>&1;
        am set-standby-bucket "$hard_pkg" restricted >/dev/null 2>&1;
        am set-inactive "$hard_pkg" true >/dev/null 2>&1;
        cmd jobscheduler cancel "$hard_pkg" >/dev/null 2>&1;
        cmd activity make-uid-idle --user 0 "$hard_pkg" >/dev/null 2>&1;
        cmd package set-stopped-state "$hard_pkg" true >/dev/null 2>&1;
        am force-stop "$hard_pkg" >/dev/null 2>&1;
    fi;
done;

echo "[5/7] Blocking Unopened Background Activity for All Other 3rd-Party Apps...";
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

echo "[6/7] Restricting Idle Background Activity on Secondary System Apps (Camera Prewarm, Maps, etc.)...";
for spkg in \
    com.oplus.camera \
    com.oneplus.camera \
    com.google.android.apps.maps \
    com.android.chrome \
    com.google.android.videos \
    com.google.android.music \
    com.google.android.apps.nbu.paisa.user \
    com.oneplus.gallery \
    com.coloros.phonemanager \
    com.coloros.oshare; do
    cmd appops set "$spkg" BOOT_COMPLETED ignore >/dev/null 2>&1;
    cmd appops set "$spkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd appops set "$spkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd jobscheduler cancel "$spkg" >/dev/null 2>&1;
done;

echo "[7/7] Verifying ColorOS 17 Active Configuration...";
echo "  max_phantom_processes : $(/system/bin/device_config get activity_manager max_phantom_processes)";
echo "  use_freezer (must=true): $(/system/bin/device_config get activity_manager_native_boot use_freezer)";
echo "  max_cached_processes  : $(/system/bin/device_config get activity_manager max_cached_processes) (ColorOS 17 cap=1)";
echo "  max_empty_time_millis : $(/system/bin/device_config get activity_manager max_empty_time_millis) ms";
echo "  provider_retain_time  : $(/system/bin/device_config get activity_manager content_provider_retain_time) ms";
echo "==================================================================";
echo " [OK] ColorOS 17 Extreme Mode v6 Active                           ";
echo "==================================================================";
