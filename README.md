# Location Changer

It automatically changes OS X’s [network location](https://support.apple.com/en-us/HT202480)
based on the name of Wi-Fi network and runs arbitrary scrips when it happens. This script is configured for Posten Norge and it's VPN, but feel free to edit it to your use.

## Installation & Update

Before you start, you need to create a network location with the name "No Proxy" (case-senstive and normal space), this can be done in your MacOS Preferences.

Install the script by running the following command in the terminal (you need admin privileges):
```
curl -L https://github.com/blt950/posten-locationchanger/raw/master/locationchanger.sh | bash
```

It will ask you for your password to install `locationchanger` to the */usr/local/bin* directory.

## Basic usage

Plug and play, everything is set up. If you connect to "posten.ikt" you'll get "Automatic" network location, all other networks will be set to "No Proxy". If you're on "No Proxy" and connect with Cisco AnyConnect to Posten VPN, it'll detect this and puts you to "Automatic".

Note: The VPN connection might require a few whiles before it's ready to go. It'll connect, then reconnect again with correct network location. It should be all ready to go once it says "Connected to Posten" the 2nd time.

## Advanced usage

This script is probably not bulletproof, so it might do some things I didn't think of yet. If you're just curious or want to read the logs, you can do that in terminal with this command

```
cat /Users/YOUR USERNAME/Library/Logs/LocationChanger.log
```
The script is triggered on system configuration changes, so it's possible it triggers some times where you didn't change your internet connection but something else in your system changed. The script should however not change or restart your connection unless you change the WiFi og toggle your VPN.
