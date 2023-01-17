# Project Notes

## Setup

### FullPageOS (CustomPiOS) Startup Procedure

- LightDM calls ```/usr/share/xsessions/guisession.desktop``` which starts matchbox-window-manager and calls ```/home/pi/scripts/run_onepageos```.
- ```run_onepageos``` starts Chromium in fullscreen and moves the mouse cursor.


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
Comment=Startup of the minimal GUI
Type=Application
```

Edit ```/boot/check_for_httpd```
```bash
enabled
```
