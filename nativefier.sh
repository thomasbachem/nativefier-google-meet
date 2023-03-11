#!/bin/sh
#set -x

# Determine directory path of this script
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Kill app if currently running
pkill "Google Meet"
PKILL=$?

# Create app bundle using https://github.com/nativefier/nativefier
nativefier \
	--name 'Google Meet' \
	--icon "$SCRIPT_DIR/icon.icns" \
	--single-instance --fast-quit \
	--hide-window-frame \
	--strict-internal-urls --internal-urls '(.*?(meet|accounts)[.]google[.]com.*?|.*?www[.]google[.]com/url.*?)' \
	--user-agent-honest \
	'https://meet.google.com/' \
	--inject ./src/_styles.css --inject ./src/urls.js \
	"$SCRIPT_DIR"

# Move new app to Applications folder
if [[ -e "$SCRIPT_DIR/Google Meet-darwin-arm64/Google Meet.app" ]]; then
	rm -rf "/Applications/Google Meet.app"
	mv "$SCRIPT_DIR/Google Meet-darwin-arm64/Google Meet.app" "/Applications/Google Meet.app"
	rm -rf "$SCRIPT_DIR/Google Meet-darwin-arm64"

	echo "Moved app to /Applications/Google Meet.app"
fi

# Launch app again if it was running before
if [[ $PKILL -eq 0 ]]; then
	open "/Applications/Google Meet.app"
fi