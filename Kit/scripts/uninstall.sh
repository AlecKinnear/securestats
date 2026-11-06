#!/bin/sh

set -u

HELPER_LABEL="com.aleckinnear.securestats.SMC.Helper"
AGENT_LABEL="com.aleckinnear.securestats"

if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    HOME=$(dscl . -read "/Users/$SUDO_USER" NFSHomeDirectory | awk '{print $2}')
fi

run_as_user() {
    if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
        sudo -u "$SUDO_USER" "$@"
    else
        "$@"
    fi
}

echo "Uninstalling Stats..."

run_as_user osascript -e 'quit app "Stats"' >/dev/null 2>&1 || true

echo "Removing the launch agent..."
if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
    GUI_UID=$(id -u "$SUDO_USER")
else
    GUI_UID=$(id -u)
fi
run_as_user launchctl bootout "gui/$GUI_UID/$AGENT_LABEL" 2>/dev/null || true
rm -f "$HOME/Library/LaunchAgents/$AGENT_LABEL.plist"

echo "Removing the SMC helper (administrator privileges are required)..."
sudo launchctl bootout "system/$HELPER_LABEL" 2>/dev/null || true
sudo launchctl unload "/Library/LaunchDaemons/$HELPER_LABEL.plist" 2>/dev/null || true
sudo rm -f "/Library/LaunchDaemons/$HELPER_LABEL.plist"
sudo rm -f "/Library/PrivilegedHelperTools/$HELPER_LABEL"

for app in "/Applications/Secure Stats.app" "$HOME/Applications/Secure Stats.app"; do
    if [ -d "$app" ]; then
        echo "Removing $app..."
        sudo rm -rf "$app"
    fi
done

echo "Removing application data and preferences..."
echo "Removing the System Stats authorization..."
run_as_user security delete-generic-password -s "${AGENT_LABEL}.remote" -a access_token 2>/dev/null || true
run_as_user security delete-generic-password -s "${AGENT_LABEL}.remote" -a refresh_token 2>/dev/null || true
rm -rf "$HOME/Library/Application Support/Secure Stats"
rm -rf "$HOME/Library/Containers/com.aleckinnear.securestats.Widgets"
rm -rf "$HOME/Library/Group Containers/"*.com.aleckinnear.securestats.widgets
run_as_user defaults delete com.aleckinnear.securestats >/dev/null 2>&1 || true
run_as_user defaults delete com.aleckinnear.securestats.Widgets >/dev/null 2>&1 || true
rm -f "$HOME/Library/Preferences/com.aleckinnear.securestats.plist"
rm -f "$HOME/Library/Preferences/com.aleckinnear.securestats.Widgets.plist"

echo "Stats has been uninstalled."
echo "If fan speeds were controlled manually, they will return to automatic control after a reboot."
