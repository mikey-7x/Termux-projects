#!/system/bin/sh
# ==============================================================================
# xs7_ramclear.sh (v6) — ColorOS 17 Ultra-Aggressive Safe RAM & Cache Purge
# Target: OnePlus 13R (CPH2691_17.0.0.105) | ColorOS 17 | 12 GB RAM
# Execution: sh /storage/emulated/0/xs7_ramclear.sh
# ==============================================================================

echo "== [1/7] FLUSHING APP CACHES, LOGD BUFFERS, PROCSTATS & EXIT INFO ==";
pm trim-caches 999999999999999999 >/dev/null 2>&1;
cmd package trim-caches 999999999999999999 internal >/dev/null 2>&1;
rm -rf /storage/emulated/0/Android/data/*/cache/* 2>/dev/null;
rm -rf /storage/emulated/0/Android/data/*/code_cache/* 2>/dev/null;
rm -rf /data/local/tmp/* 2>/dev/null;
logcat -b all -c >/dev/null 2>&1;
cmd activity clear-exit-info >/dev/null 2>&1;
dumpsys procstats --clear >/dev/null 2>&1;
dumpsys batterystats --reset >/dev/null 2>&1;

echo "== [2/7] ENFORCING COLOROS 17 1-PROCESS CACHE CAP & COMPACTION ==";
/system/bin/device_config set_sync_disabled_for_tests persistent >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_phantom_processes 2147483647 >/dev/null 2>&1;
settings put global max_phantom_processes 2147483647 >/dev/null 2>&1;
/system/bin/device_config put activity_manager_native_boot use_freezer true >/dev/null 2>&1;
settings put global cached_apps_freezer enabled >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_cached_processes 1 >/dev/null 2>&1;
/system/bin/device_config put activity_manager cur_max_cached_processes 1 >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_empty_time_millis 5000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager content_provider_retain_time 20000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager max_service_inactivity 15000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager bg_settle_time 5000 >/dev/null 2>&1;
/system/bin/device_config put activity_manager use_compaction true >/dev/null 2>&1;
/system/bin/device_config put runtime_native usap_pool_enabled false >/dev/null 2>&1;
settings put system oplus_app_preload_switch 0 >/dev/null 2>&1;
settings put global oplus_app_preload_switch 0 >/dev/null 2>&1;

echo "== [3/7] STOPPING COLOROS 17 TELEMETRY (POWER MONITOR 46MB, STDID, AD PRIVACY, ACCOUNT 59MB) ==";
for sys_pkg in \
    com.oplus.powermonitor \
    com.oplus.stdid \
    com.google.android.adservices.api \
    com.android.adservices.api \
    com.google.android.as.oss \
    com.heytap.usercenter \
    com.oplus.vip \
    com.oneplus.account \
    com.oplus.pantanal.ums \
    com.oplus.obrain \
    com.oplus.metis \
    com.oplus.SmartEngine \
    com.oplus.cosa \
    com.oplus.ocar \
    com.oplus.synergy \
    com.oplus.linker \
    com.oplus.olc \
    com.oplus.onetrace \
    com.oplus.qualityprotect \
    com.oplus.deepthinker \
    com.google.android.aicore \
    com.google.android.safetycore \
    com.facebook.services \
    com.facebook.system \
    com.facebook.appmanager \
    com.heytap.htms \
    com.heytap.cloud \
    com.heytap.mcs \
    com.heytap.accessory \
    com.heytap.habit.analysis \
    com.oplus.logkit \
    com.oplus.crashbox \
    com.oplus.statistics.rom \
    com.oplus.lfeh \
    com.coloros.activation; do
    pm disable-user --user 0 "$sys_pkg" >/dev/null 2>&1;
    am force-stop "$sys_pkg" >/dev/null 2>&1;
done;

echo "== [4/7] PROTECTING TERMUX SUITE & HARD-KILLING FACEBOOK, GDRIVE, GMAIL (374MB) & MICROG ==";
for keep_pkg in com.termux com.termux.x11 com.termux.api com.termux.widget com.termux.boot com.termux.styling; do
    if pm list packages "$keep_pkg" 2>/dev/null | grep -q "^package:$keep_pkg$"; then
        dumpsys deviceidle whitelist +"$keep_pkg" >/dev/null 2>&1;
        am set-standby-bucket "$keep_pkg" active >/dev/null 2>&1;
        am set-inactive "$keep_pkg" false >/dev/null 2>&1;
        cmd appops set "$keep_pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1;
        cmd appops set "$keep_pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1;
        cmd appops set "$keep_pkg" START_FOREGROUND allow >/dev/null 2>&1;
        cmd appops set "$keep_pkg" WAKE_LOCK allow >/dev/null 2>&1;
    fi;
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
        cmd appops set "$hard_pkg" WAKE_LOCK ignore >/dev/null 2>&1;
        cmd appops set "$hard_pkg" GET_ACCOUNTS ignore >/dev/null 2>&1;
        am set-standby-bucket "$hard_pkg" restricted >/dev/null 2>&1;
        am set-inactive "$hard_pkg" true >/dev/null 2>&1;
        cmd jobscheduler cancel "$hard_pkg" >/dev/null 2>&1;
        cmd activity make-uid-idle --user 0 "$hard_pkg" >/dev/null 2>&1;
        cmd package set-stopped-state "$hard_pkg" true >/dev/null 2>&1;
        am force-stop "$hard_pkg" >/dev/null 2>&1;
    fi;
done;

echo "== [5/7] STOPPING UNLAUNCHED 3RD-PARTY APPS ==";
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
    cmd package set-stopped-state "$pkg" true >/dev/null 2>&1;
    am force-stop "$pkg" >/dev/null 2>&1;
done;

echo "== [6/7] EVICTING PRE-WARMED CAMERA & IDLE SYSTEM APPS (KEPT ENABLED FOR WHEN YOU OPEN THEM) ==";
for spkg in \
    com.oplus.camera \
    com.oneplus.camera \
    com.google.android.apps.bard \
    com.oplus.aistudio \
    com.coloros.aistudio \
    com.coloros.video \
    com.oppo.quicksearchbox \
    com.heytap.quicksearchbox \
    com.coloros.securepay \
    com.oplus.securepay \
    com.google.android.apps.maps \
    com.android.chrome \
    com.google.android.videos \
    com.google.android.music \
    com.google.android.apps.nbu.paisa.user \
    com.oneplus.gallery \
    com.coloros.phonemanager \
    com.coloros.oshare \
    com.coloros.calculator \
    com.coloros.alarmclock \
    com.coloros.soundrecorder \
    com.oplus.cast; do
    cmd appops set "$spkg" BOOT_COMPLETED ignore >/dev/null 2>&1;
    cmd appops set "$spkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd appops set "$spkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1;
    cmd jobscheduler cancel "$spkg" >/dev/null 2>&1;
    am force-stop "$spkg" >/dev/null 2>&1;
done;

echo "== [7/7] KILLING ALL CACHED PROCESSES & TRIMMING 5.8GB SYSTEM HEAPS ==";
am kill-all >/dev/null 2>&1;

for rproc in $(ps -A -o NAME 2>/dev/null | grep '\.' | sort -u); do
    case "$rproc" in
        com.termux*|in.sunilpaulmathew.ashell*|moe.shizuku.privileged.api*)
            continue
            ;;
    esac;
    am send-trim-memory "$rproc" RUNNING_CRITICAL >/dev/null 2>&1;
    am send-trim-memory "$rproc" COMPLETE >/dev/null 2>&1;
done;

sleep 1;
am kill-all >/dev/null 2>&1;
echo "== FREE RAM AFTER COLOROS 17 v6 ULTRA PURGE ==";
grep -E '^(MemTotal|MemFree|MemAvailable|Cached|SwapFree):' /proc/meminfo;
echo "== VERIFYING FACEBOOK, GDRIVE, GMAIL & POWER MONITOR ARE 100% DEAD ==";
ps -A -o NAME | grep -E 'facebook|apps\.docs|android\.gm$|powermonitor|stdid|adservices' || echo " -> [OK] 0 Bloat/Cached processes running!";
