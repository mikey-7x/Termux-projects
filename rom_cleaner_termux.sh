#!/system/bin/sh
# Conservative per-app background policy for Android/OxygenOS.
# Restricts installed third-party apps except WhatsApp, Termux, aShell, Shizuku.
# WhatsApp + Google push services stay allowed for notification delivery.
# No global zero-cache cap, no app-data/cache deletion, no system package disabling.
# Run from aShell with Shizuku authorization or from adb shell.

set +e

say() { echo "$1"; }

say "== Restore Android-managed process/cache defaults changed by older scripts =="
/system/bin/device_config set_sync_disabled_for_tests none >/dev/null 2>&1
for key in max_cached_processes cur_max_cached_processes cur_max_empty_processes max_empty_time_millis content_provider_retain_time background_settle_time; do
    /system/bin/device_config delete activity_manager "$key" >/dev/null 2>&1
done
/system/bin/device_config delete activity_manager_native_boot use_freezer >/dev/null 2>&1
settings delete global cached_apps_freezer >/dev/null 2>&1

say "== Restore Drive file-picker/sync and packages disabled by older scripts =="
pm enable --user 0 com.google.android.apps.docs/com.google.android.apps.docs.storagebackend.StorageBackendContentProvider >/dev/null 2>&1
pm enable --user 0 com.google.android.apps.docs/com.google.android.apps.docs.sync.syncadapter.DocsSyncAdapterService >/dev/null 2>&1
for pkg in com.google.android.aicore com.facebook.services com.facebook.system com.facebook.appmanager com.heytap.cloud com.heytap.mcs com.heytap.accessory com.heytap.habit.analysis com.oplus.stdid com.oplus.logkit com.oplus.crashbox com.oplus.statistics.rom com.oplus.lfeh com.coloros.activation; do
    pm enable --user 0 "$pkg" >/dev/null 2>&1
done

say "== Restrict background activity for other installed user apps =="
for pkg in $(pm list packages -3 2>/dev/null | sed 's/^package://'); do
    # First undo broad AppOps overrides from the older script; apply this policy below.
    cmd appops set "$pkg" RUN_IN_BACKGROUND default >/dev/null 2>&1
    cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND default >/dev/null 2>&1
    cmd appops set "$pkg" BOOT_COMPLETED default >/dev/null 2>&1
    cmd appops set "$pkg" WAKE_LOCK default >/dev/null 2>&1
    cmd appops set "$pkg" START_FOREGROUND default >/dev/null 2>&1
    case "$pkg" in
        com.whatsapp|com.termux*|in.sunilpaulmathew.ashell|moe.shizuku.privileged.api)
            continue
            ;;
    esac
    dumpsys deviceidle whitelist -"$pkg" >/dev/null 2>&1
    cmd appops set "$pkg" RUN_IN_BACKGROUND ignore >/dev/null 2>&1
    cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND ignore >/dev/null 2>&1
    cmd appops set "$pkg" BOOT_COMPLETED ignore >/dev/null 2>&1
    am set-standby-bucket "$pkg" restricted >/dev/null 2>&1
    am set-inactive "$pkg" true >/dev/null 2>&1
    am force-stop "$pkg" >/dev/null 2>&1
done

say "== Allow WhatsApp background messaging and Google push transport =="
dumpsys deviceidle whitelist +com.whatsapp >/dev/null 2>&1
cmd appops set com.whatsapp RUN_IN_BACKGROUND allow >/dev/null 2>&1
cmd appops set com.whatsapp RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1
cmd appops set com.whatsapp WAKE_LOCK allow >/dev/null 2>&1
cmd appops set com.whatsapp START_FOREGROUND allow >/dev/null 2>&1
cmd appops set com.whatsapp BOOT_COMPLETED default >/dev/null 2>&1
am set-standby-bucket com.whatsapp active >/dev/null 2>&1
am set-inactive com.whatsapp false >/dev/null 2>&1
dumpsys deviceidle whitelist +com.google.android.gms >/dev/null 2>&1
dumpsys deviceidle whitelist +com.google.android.gsf >/dev/null 2>&1

say "== Preserve Termux/X11 tools =="
for pkg in com.termux com.termux.x11 com.termux.api; do
    dumpsys deviceidle whitelist +"$pkg" >/dev/null 2>&1
    cmd appops set "$pkg" RUN_IN_BACKGROUND allow >/dev/null 2>&1
    cmd appops set "$pkg" RUN_ANY_IN_BACKGROUND allow >/dev/null 2>&1
    cmd appops set "$pkg" WAKE_LOCK allow >/dev/null 2>&1
done

say "== Verification: WhatsApp policy =="
cmd appops get com.whatsapp RUN_IN_BACKGROUND 2>/dev/null
cmd appops get com.whatsapp RUN_ANY_IN_BACKGROUND 2>/dev/null
cmd appops get com.whatsapp WAKE_LOCK 2>/dev/null
am get-standby-bucket com.whatsapp 2>/dev/null
say "== Verification: target background restrictions =="
for pkg in com.facebook.katana com.google.android.apps.docs; do
    if pm path "$pkg" >/dev/null 2>&1; then
        echo "--- $pkg ---"
        cmd appops get "$pkg" RUN_IN_BACKGROUND 2>/dev/null
        cmd appops get "$pkg" RUN_ANY_IN_BACKGROUND 2>/dev/null
        am get-standby-bucket "$pkg" 2>/dev/null
    fi
done
say "Done. Android may still start a restricted app when a system feature explicitly needs it."
say "WhatsApp real-time delivery requires background execution; this script intentionally permits it."
