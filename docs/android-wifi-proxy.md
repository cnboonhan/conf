# android-wifi-proxy

Instructions to set up android device for VPN proxy.

```
# Connect to Wifi on phone

# Install Shelter, get up Work Profile
https://m.apkpure.com/shelter/net.typeblog.shelter

# Install Google Chrome, SimpleSSHD and GlobalProtect in Work Profile
https://www.apkmirror.com/apk/google-inc/chrome/
https://m.apkpure.com/globalprotect/com.paloaltonetworks.globalprotect
https://m.apkpure.com/simplesshd/org.galexander.sshd

# Install Fdroid and Termux ( from Fdroid ) on Personal
https://m.apkpure.com/netshare-no-root-tethering/kha.prog.mikrotik
https://f-droid.en.softonic.com/android

# On termux, run
pkg update
pkg install openssh iproute2 tmux avahi dnsutils traceroute privoxy
whoami    # Remember this
ip a      # Get Ip address of phone
passwd    # Set password

# Open Work Profile and run SimpleSSHD
# Run GlobalProtect and Login

# Disable App Management ( to prevent phone from terminating apps ) for Termux, OpenSSHD

# Start sshd and avahi-deamon on phone
sshd
avahi-daemon

# From Client
Replace User and Hostname as needed
tee -a ~/.ssh/config << END
Host Q
        User u0_a184
        HostName linux.local
        Port 8022
        IdentityFile ~/.ssh/id_rsa
END

ssh Q
tmux attach

# Set up SOCKS5 proxy to OpenSSHD
ssh 127.0.0.1 -p 2222 -D 1080

# Set up Privoxy for HTTP proxy
tee -a /etc/privoxy/config << END
forward-socks5t / 127.0.0.1:1080 .
listen-address 0.0.0.0:1090
END
privoxy config

# Add this command to .bashrc and run it
proxy-start() {
    privoxy /etc/privoxy/config
    ssh 127.0.0.1 -p 2222 -D 1080
}

# Connect to HTTP proxy at port 1090

```
