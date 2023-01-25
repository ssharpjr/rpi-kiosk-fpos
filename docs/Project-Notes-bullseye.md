# Project Notes

Debian Bullseye minimal install


## Setup

### Packages

Packages to install (*currently not using ```compton```*)
```bash
sudo apt install xserver-xorg x11-utils xdotool lightdm matchbox-window-manager compton chromium chromium-l10n
```


### LightDM Startup Procedure

LightDM calls ```/usr/share/xsessions/guisession.desktop```  
Which runs ```/home/user/scripts/start_gui```  
Which runs ```/home/user/scripts/start_app```  
Which runs ```/home/user/scripts/start_browser```  
Which calls ```/boot/link.txt```, the web page to display


### Configure LightDM

Edit ```/etc/lightdm/lightdm.conf```
```bash
[LightDM]

[Seat:*]
user-session=guisession
autologin-user=pi
```

Edit ```/usr/share/xsessions/guisession.desktop```
```bash
[Desktop Entry]
Version=1.0
Name=GUISession
Exec=/home/pi/scripts/start_gui
Comment=Minimal GUI Startup
Type=Application
```


### Auto-Login User

Create ```/etc/systemd/system/getty@tty1.service.d/override.conf``` file
```bash
sudo systemctl edit getty@tty1.service
```

Enter the following and save the file
```bash
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin myusername %I $TERM
Type=idle
```