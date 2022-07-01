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
pkg install openssh iproute2 tmux avahi dnsutils traceroute privoxy openssl-tool
whoami    # Remember this
ip a      # Get Ip address of phone
passwd    # Set password

# Use this to install linux distro on termux
# https://github.com/termux/proot-distro
pkg install proot-distro
proot-distro install debian

# Open Work Profile and run SimpleSSHD
# Run GlobalProtect and Login

# Disable App Management ( to prevent phone from terminating apps ) for Termux, OpenSSHD

Replace User and Hostname as needed
tee -a ~/.ssh/config << END
Host Q
        User root
        HostName linux.local
        Port 8022
        IdentityFile ~/.ssh/id_rsa
END

# Set up Privoxy for HTTP proxy
tee -a /etc/privoxy/config << END
forward-socks5t / 127.0.0.1:1080 .
listen-address 0.0.0.0:1090
END
privoxy config

# Set up .profile in termux
tee -a .profile << END
SESSION_NAME=proot

sshd

if [[ ! "$TMUX" ]]; then
  tmux has-session -t $SESSION_NAME 2> /dev/null

  if [ $? != 0 ]; then
    tmux new-session -d -s $SESSION_NAME

    tmux rename-window -t $SESSION_NAME:0 proot
    tmux send -t $SESSION_NAME:proot.0 "proot-distro login debian" ENTER
    tmux send -t $SESSION_NAME:proot.0 "ttyd -p 18000 login" ENTER

    tmux new-window -t $SESSION_NAME:1 -n "novnc"
    tmux send -t $SESSION_NAME:novnc.0 "$HOME/noVNC/utils/novnc_proxy --vnc localhost:5901" ENTER

    tmux new-window -t $SESSION_NAME:2 -n "privoxy"
    tmux send -t $SESSION_NAME:privoxy.0 "proot-distro login debian" ENTER
    tmux send -t $SESSION_NAME:privoxy.0 "privoxy /etc/privoxy/config; ssh 127.0.0.1 -p 2222 -D 1080" ENTER

    tmux new-window -t $SESSION_NAME:3 -n "mdns"
    tmux send -t $SESSION_NAME:mdns.0 "pkill avahi-daemon; avahi-daemon" ENTER
  fi
fi
END

# Connect to HTTP proxy at linux.local:1090

# Additional: Add termux-desktop + noVNC
cd $HOME
pkg upgrade && pkg install git
git clone --depth=1 https://github.com/adi1090x/termux-desktop.git
cd termux-desktop; ./setup.sh --install

cd $HOME
pkg install otter-browser
git clone https://github.com/novnc/noVNC.git
$HOME/noVNC/utils/novnc_proxy --vnc localhost:5901
```
