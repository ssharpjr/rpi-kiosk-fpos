# Project Notes

Debian Bullseye minimal install built from Armbian for the LePotato from Libre.Computer.  
*(All commands are run as if from the root folder of this project)*


## Base Setup

### Armbian Config

- Create root password
- Create new user: ```runner```
- If prompted, setup Wi-Fi
- Timezone: America/New_York (Denver)
- Locale: en_US.UTF-8
- Reboot
- Log in as ```runner``` to complete the setup/install


### Networking

Create a Wi-Fi connection using ```nmtui``` if needed.


### Packages

Packages to install *(currently not using ```compton```)*
```bash
sudo apt install -y git vim xserver-xorg x11-xserver-utils xdotool lightdm matchbox-window-manager chromium
```


### Create User and Set Auto-Login

Create ```runner``` user (if needed)
```bash
sudo adduser --disabled-login --gecos "" runner
sudo usermod -G tty,disk,dialout,sudo,audio,video,plugdev,games,users,systemd-journal,input,netdev,ssh -a runner
```

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
*@@TODO WIP*


### Copy Scripts
Copy all scripts to ```/usr/local/bin```
```bash
sudo cp scripts/* /usr/local/bin/
```


## GUI Setup

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


## Watchdogs

### Cron Jobs
Copy cron job scripts to ```/usr/local/bin``` *(if needed)*  
Add cron jobs to the current user.  
```bash
crontab cron/reboot_on_browser_fail.cron
crontab cron/refresh_browser.cron
crontab cron/reset_network_on_fail.cron
```