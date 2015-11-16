#!/bin/sh

exec osascript << EOF
    tell application "System Events"
		tell process "Chrome"
			delay 1
			key code 52
		end tell
     end tell

EOF
    exit 0
