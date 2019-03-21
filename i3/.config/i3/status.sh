#!/bin/bash
INTERVAL="30s"
MAIN_COLOR="#304155"
HIGHLIGHT_COLOR="#1e6d51"
ERROR_COLOR="#FF0000"

function toJson() {
    echo -n "{ \"full_text\" : \"$1\", \"color\" : \"$2\" }"
}

function AUTO_MAIL_CHECK_ACTIVE() {
    systemctl --quiet --user is-active mbsync.timer
    timerActive=$?
    syncInProgress=$(systemctl --user is-active mbsync.service | head -1)
    systemctl --quiet --user is-failed mbsync.service
    failed=$?

    if [[ "$syncInProgress" == "activating" ]]; then
        echo $(toJson "痢" "$HIGHLIGHT_COLOR"),
    elif [[ "$timerActive" == 0 && "$failed" == 0 ]]; then
        echo $(toJson "痢" "$ERROR_COLOR"),
    elif [[ "$timerActive" == 0 ]]; then
        echo $(toJson "痢" "$MAIN_COLOR"),
    fi
}

function MAIL_COUNT() {
    MAILBOX_DIR="$HOME/.local/share/mail/"
    MAILBOXES=(\
        "mailbox/INBOX"\
        "mailbox/login"\
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
    PKGLIST_FILE="$HOME/.cache/pacman-updates/pkgList"
    if [[ -f "$PKGLIST_FILE" && "$(cat $PKGLIST_FILE | wc -l)" > 0 ]]; then
        echo $(toJson " $(cat $HOME/.cache/pacman-updates/pkgList | wc -l)" "$HIGHLIGHT_COLOR"),
    fi
}

function GEO_LOCATION() {
    GEO_LOCATION_FILE="$HOME/.cache/geolocation"
    if [[ -f "$GEO_LOCATION_FILE" && $(cat "$GEO_LOCATION_FILE") != "Offline" ]]; then
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
    BATT_FILE="/sys/class/power_supply/BAT0/capacity"
    if [[ ! -f "$BATT_FILE" ]]; then return; fi
    LEVEL=$(cat "$BATT_FILE")
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
