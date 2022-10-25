# Raspberry Pi Kiosk Notes

## FullPageOS (CustomPiOS) Startup Procedure
- LightDM calls ```/usr/share/xsessions/guisession.desktop``` which starts matchbox-window-manager and calls ```/home/pi/scripts/run_onepageos```.
- ```run_onepageos``` starts Chromium in fullscreen and moves the mouse cursor.
