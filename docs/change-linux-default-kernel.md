# check-linux-default-kernel

```
# edit grub
sudo vim /etc/default/grub
# Add the following
GRUB_SAVEDEFAULT=true
GRUB_DEFAULT=saved

# update
sudo update-grub

# Now, the kernel you select at boot should become default
```
