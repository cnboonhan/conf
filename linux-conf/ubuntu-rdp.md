# ubuntu-rdp

Configurations to get ubuntu desktop sharing over RDP to work.

```
# login using wayland desktop environment
gsettings set org.gnome.desktop.remote-desktop.rdp screen-share-mode extend
gsettings set org.gnome.desktop.remote-desktop.rdp enable true
gsettings set org.gnome.desktop.remote-desktop.rdp view-only false
# configure "Password and Keys" "GNOME Remote Desktop RDP Credentials" to fix a password
```
