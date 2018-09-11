#!/bin/bash

INSTALL_DIR=/usr/local/bin
SCRIPT_NAME=$INSTALL_DIR/locationchanger
LAUNCH_AGENTS_DIR=$HOME/Library/LaunchAgents
PLIST_NAME=$LAUNCH_AGENTS_DIR/LocationChanger.plist

sudo -v

sudo mkdir -p $INSTALL_DIR
cat << "EOT" | sudo tee $SCRIPT_NAME > /dev/null
#!/bin/bash

# This script changes network location based on the name of Wi-Fi network.

#!/bin/bash

# This script changes network location based on the name of Wi-Fi network.
# Ment for Posten Norge, but feel free to edit to your needs.

exec 2>&1 >> $HOME/Library/Logs/LocationChanger.log

ts() {
    date +"[%Y-%m-%d %H:%M] $*"
}

SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep ' SSID' | cut -d : -f 2- | sed 's/^[ ]*//'`

LOCATION_NAMES=`scselect | tail -n +2 | cut -d \( -f 2- | sed 's/)$//'`
CURRENT_LOCATION=`scselect | tail -n +2 | egrep '^\ +\*' | cut -d \( -f 2- | sed 's/)$//'`

ts "Connected to '$SSID'"

CONFIG_FILE=$HOME/.locations/locations.conf

if [ "$SSID" = "posten.ikt" ]; then # Check for Posten domains
	NEW_LOCATION=Automatic
    ts "Location '$SSID' is Posten domain."
else
	# Check if VPN is enabled
	if [[ "{$(/opt/cisco/anyconnect/bin/vpn status)[0]}" != *"Disconnected"* ]]; then
		NEW_LOCATION=Automatic
		ts "Location '$SSID' is NOT a Posten domain, but VPN ACTIVE."
	else
		NEW_LOCATION="No Proxy"
		ts "Location '$SSID' is NOT a Posten domain."
	fi
fi

if [ "$NEW_LOCATION" != "" ]; then
    if [ "$NEW_LOCATION" != "$CURRENT_LOCATION" ]; then
        ts "Changing the location to '$NEW_LOCATION'"
        scselect "$NEW_LOCATION"
        SCRIPT="$HOME/.locations/$NEW_LOCATION"
        if [ -f "$SCRIPT" ]; then
            ts "Running '$SCRIPT'"
            "$SCRIPT"
        fi
    else
        ts "Already at '$NEW_LOCATION'"
    fi
fi
EOT

sudo chmod +x $SCRIPT_NAME

mkdir -p $LAUNCH_AGENTS_DIR
cat > $PLIST_NAME << EOT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>locationchanger</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/locationchanger</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/Library/Preferences/SystemConfigurationt</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOT

launchctl load $PLIST_NAME
