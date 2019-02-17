#!/bin/bash
INTERVAL="30s"
MAIN_COLOR="#304155"
HIGHLIGHT_COLOR="#1e6d51"
ERROR_COLOR="#FF0000"

function toJson() {
    echo -n "{ \"full_text\" : \"$1\", \"color\" : \"$2\" }"
}

function AUTO_MAIL_CHECK_ACTIVE() {
    systemctl --quiet --user is-active offlineimap-oneshot@\*.timer
    timerActive=$?
    systemctl --quiet --user is-failed offlineimap-oneshot@\*.service
    failed=$?

    if [[ "$timerActive" == 0 && "$failed" == 0 ]]; then
        echo $(toJson " " "$ERROR_COLOR"),
    elif [[ "$timerActive" == 0 ]]; then
        echo $(toJson " " "$MAIN_COLOR"),
    fi
}

function MAIL_COUNT() {
    MAILBOX_DIR="$HOME/.local/share/mail/"
    MAILBOXES=(\
        "mailbox/INBOX"\
        "mailbox/login"\
        "mailbox/mailing_lists"\
        "uni/INBOX"\
        "uni/moodle"\
    )
    total=0
    for i in ${MAILBOXES[*]}; do
        new=$(find "$MAILBOX_DIR/$i/new" -type f | wc -l)
        total=$(($total + $new))
    done
    if [[ "$total" -gt "0" ]]; then
        echo $(toJson " $total" "$MAIN_COLOR"),
    fi
}

function PKG_COUNT() {
    if [[ "$(cat $HOME/.cache/pacman-updates/pkgList | wc -l)" > 0 ]]; then
        echo $(toJson " $(cat $HOME/.cache/pacman-updates/pkgList | wc -l)" "$HIGHLIGHT_COLOR"),
    fi
}

function GEO_LOCATION() {
    if [[ $(cat "$HOME/.cache/geolocation") != "Offline" ]]; then
        echo $(toJson " $(cat $HOME/.cache/geolocation)" "$MAIN_COLOR"),
    fi
}

function NETWORK() {
    if [[ "$(nmcli network connectivity)" == full ]]; then
        echo $(toJson "" "$MAIN_COLOR"),
    fi 
}

function DISK_SPACE() {
    SPACE=$(df -h /dev/mapper/archVG-home | tail -1 | awk '{print $4}')
    echo $(toJson " $SPACE" "$MAIN_COLOR"),
}

function BATTERY() {
    LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
    COLOR="$MAIN_COLOR"
    if [[ "$LEVEL" -lt "20" ]]; then
        COLOR="$HIGHLIGHT_COLOR"
    fi
    echo $(toJson " ${LEVEL}%" "$COLOR"),
}

# Last one. Therefore this won't end on ,
function TIME() {
    echo $(toJson "$(date +%H:%M)" "$MAIN_COLOR")
}

# Send the header so that i3bar knows we want to use JSON:
echo '{ "version" : 1 }'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[],'

while true; do
    echo "["
    echo "$(PKG_COUNT)"
    echo "$(MAIL_COUNT)"
    echo "$(GEO_LOCATION)"
    echo "$(DISK_SPACE)"
    echo "$(BATTERY)"
    echo "$(AUTO_MAIL_CHECK_ACTIVE)"
    echo "$(TIME)"
    echo "],"
    
    sleep "$INTERVAL"
done