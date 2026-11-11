#!/system/bin/sh
# =========================================================================
# Project   : mikey-7x/Termux-projects — ColorOS 17 Safe System Debloater (v6)
# Script    : debloat_13r_safe.sh
# Target    : OnePlus 13R (CPH2691_17.0.0.105) / ColorOS 17 & OxygenOS 16
# Purpose   : Disables ColorOS 17 telemetry, Power Monitor (46MB), Ad Privacy,
#             OnePlus Account (59MB), StdID, and bloatware while keeping
#             Gemini, Google Discover, AI Studio, Videos (System), Global
#             Search, Payment Protection, and Termux 100% intact.
# =========================================================================

echo "== [ONEPLUS 13R COLOROS 17 SAFE DEBLOAT & ROM CLEANER v6] ==";
echo "Storage before:";
df -h /data;

# Ensure your actively used apps stay enabled
for keep_app in \
    com.coloros.video \
    com.oplus.aistudio \
    com.coloros.aistudio \
    com.google.android.apps.bard \
    com.google.android.googlequicksearchbox \
    com.oppo.quicksearchbox \
    com.heytap.quicksearchbox \
    com.coloros.securepay \
    com.oplus.securepay; do
    pm enable "$keep_app" >/dev/null 2>&1;
done;

SAFE_BLOAT_PKGS="
com.oplus.powermonitor
com.oplus.stdid
com.google.android.adservices.api
com.android.adservices.api
com.google.android.as.oss
com.heytap.usercenter
com.oplus.vip
com.oneplus.account
com.oplus.pantanal.ums
com.oplus.obrain
com.oplus.metis
com.oplus.SmartEngine
com.oplus.cosa
com.oplus.ocar
com.oplus.synergy
com.oplus.linker
com.oplus.olc
com.oplus.onetrace
com.oplus.qualityprotect
com.oplus.deepthinker
com.google.android.projection.gearhead
com.google.android.apps.restore
com.google.android.safetycore
com.google.android.aicore
com.google.android.apps.wellbeing
com.oplus.dmp
com.google.ar.core
com.google.android.apps.walletnfcrel
com.heytap.cloud
com.heytap.browser
com.oneplus.asti
com.coloros.childrenspace
com.google.ar.lens
com.microsoft.appmanager
com.heytap.pictorial
com.google.android.apps.tachyon
com.facebook.system
com.facebook.appmanager
com.facebook.services
com.heytap.mcs
com.heytap.accessory
com.heytap.habit.analysis
com.heytap.htms
com.oneplus.membership
com.oplus.widget
com.redteamobile.roaming
com.oplus.outdoormode
com.google.android.apps.safetyhub
com.google.android.apps.photos
com.android.traceur
com.heytap.market
com.heytap.themestore
com.oppo.themestore
com.coloros.weather2
com.coloros.weather.service
com.google.android.youtube
com.google.android.apps.nbu.files
com.oplus.games
com.oplus.logkit
com.oplus.crashbox
com.oplus.statistics.rom
com.oplus.lfeh
com.coloros.activation
com.oneplus.opshelf
com.oplus.shelf
com.oplus.mindspace
com.coloros.mindspace
com.coloros.systemclone
com.oplus.systemclone
com.google.android.partnersetup
com.google.android.apps.setupwizard.searchselector
com.google.android.marvin.talkback
com.google.android.feedback
com.google.android.printservice.recommendation
";

COUNT=0;
for pkg in $SAFE_BLOAT_PKGS; do
  if pm list packages "$pkg" 2>/dev/null | grep -q "^package:$pkg$"; then
    echo " -> Cleaning & disabling ColorOS 17 bloat: $pkg";
    am force-stop "$pkg" >/dev/null 2>&1;
    pm uninstall-system-updates "$pkg" >/dev/null 2>&1;
    pm clear "$pkg" >/dev/null 2>&1;
    pm disable-user --user 0 "$pkg" >/dev/null 2>&1;
    COUNT=$((COUNT + 1));
  fi;
done;

pm trim-caches 999999999999999999 >/dev/null 2>&1;
echo "== DONE: $COUNT COLOROS 17 BLOAT PACKAGES CLEANED SAFELY ==";
echo "Storage after:";
df -h /data;
grep -E '^(MemTotal|MemFree|MemAvailable|Cached):' /proc/meminfo;
