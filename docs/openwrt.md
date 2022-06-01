# OpenWRT router config
```
# Install usb dongle kernel support
opkg update
opkg install kmod-usb-net-rndis

# On rpi zero, add the following to wpa_supplicant.conf
network={
  ssid='hotspot'
  scan_ssid=1        # If hidden network
  psk='password'
}

systemctl enable ssh
```
