#!/bin/sh

exec osascript << EOF
    tell application "System Events"
	tell process "Chrome"
		delay 1
		keystroke "o" using {command down}
		delay 1
		keystroke "/"
		delay 1
		keystroke "Users/kr/autotest/case/upload/img/img3.jpg"
		delay 1
		key code 52
		delay 1
		key code 52
	end tell
     end tell

EOF
    echo "CCC"
    exit 0
