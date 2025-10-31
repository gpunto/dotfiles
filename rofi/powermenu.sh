#!/usr/bin/env bash

shutdown=$'\tShutdown'
reboot=$'\tReboot'
suspend=$'󰒲\tSuspend'
logout=$'󰿅\tLogout'

rofi_cmd() {
    rofi -dmenu -i -p "Power Menu"
}

chosen="$(echo -e "$suspend\n$logout\n$shutdown\n$reboot" | rofi_cmd)"

case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $suspend)
        systemctl suspend
        ;;
    $logout)
        hyprctl dispatch exit
        ;;
esac
