

# 1) DBUS call

# This works
# qdbus org.kde.plasma.browser_integration  /TabsRunner GetTabs

# This does not
# dbus-send --type="method_call" --dest=org.kde.plasma.browser_integration TabsRunner/GetTabs org.kde.plasma.browser_integration

# 2) Can be parsed in json?


# 3) Send to firefox



