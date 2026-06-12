#!/bin/bash
# sudo usermod -aG video dwara-xephyr
if [ "$EUID" -ne 0 ]; then
    if ! pactl list modules short 2>/dev/null | grep -q module-native-protocol-tcp; then
        pactl load-module module-native-protocol-tcp \
            auth-ip-acl=127.0.0.1 \
            auth-anonymous=1 >/dev/null 2>&1
    fi
    exec sudo "$0" "$@"
fi
exec >/dev/null 2>&1
pkill Xephyr
nohup Xephyr -br -ac -noreset -screen 1920x1080 :1 &
sleep 2
nohup su - dwara-xephyr -c '
export PULSE_SERVER=127.0.0.1
export DISPLAY=:1
exec xfce4-session
' &
exit 0
