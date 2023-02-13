# Project Notes

Debian Bullseye minimal install


## Setup

### Packages

Packages to install (*currently not using ```compton```*)
```bash
sudo apt install xserver-xorg x11-xserver-utils xdotool lightdm matchbox-window-manager compton chromium
```


### LightDM Startup Procedure
*(Assumes scripts have been copied to ```/usr/local/bin```)*

LightDM calls ```/usr/share/xsessions/guisession.desktop```  
Which runs ```/usr/local/bin/start_gui```  
Which runs ```/usr/local/bin/start_app```  
Which runs ```/usr/local/bin/start_browser```  
Which calls ```/boot/link.txt```, the web page to display


### Configure LightDM

Edit ```/etc/lightdm/lightdm.conf```
```bash
[LightDM]

[Seat:*]
user-session=guisession
autologin-user=runner
```

Create ```/usr/share/xsessions/guisession.desktop```
```bash
[Desktop Entry]
Version=1.0
Name=GUISession
Exec=/usr/local/bin/start_gui
Comment=Minimal GUI Startup
Type=Application
```


### Create User and Set Auto-Login


Create ```/etc/systemd/system/getty@tty1.service.d/override.conf``` file
```bash
sudo systemctl edit getty@tty1.service
```

Enter the following and save the file
```bash
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin runner %I $TERM
Type=idle
```


### X11VNC Setup
Install ```x11vnc```
```bash
sudo apt install x11vnc -y
```
@@TODO WIP


### Cron Jobs
Copy cron job scripts to ```/usr/local/bin```.  
Add cron jobs to the current user.  
```bash
crontab cron/reboot_on_browser_fail.cron
crontab cron/refresh_browser.cron
crontab cron/reset_network_on_fail.cron
```
