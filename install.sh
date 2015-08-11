#!/bin/sh
# Usage: DROPBOXID=<ID> [NO_TERMINAL_NOTIFIER=1] sh install.sh

plist_destination=~/Library/LaunchAgents/net.nevercraft.dropbox-screenshots.plist

if [ -f "$plist_destination" ]; then
  echo "$plist_destination already exists! Aborting!"
  exit 1
fi

if [ -z "$DROPBOXID" ]; then
  echo "DROPBOXID not set!"
  exit 1
fi

terminal_notifier() {
  cmd="$(command -v "terminal-notifier")"

  if [ -z "$NO_TERMINAL_NOTIFIER" ] && [ -n "$cmd" ]; then
    echo "          $cmd -title \"Copied Public Link to Clipboard\" -message \"\$url\" -execute \"open \\\"\$url\\\"\""
  fi
}

{ cat <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>net.nevercraft.dropbox-screenshots</string>
    <key>WatchPaths</key>
    <array>
      <string>$HOME/Desktop</string>
    </array>
    <key>ExitTimeOut</key>
    <integer>0</integer>
    <key>ThrottleInterval</key>
    <integer>1</integer>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/sh</string>
      <string>-c</string>
      <string>
        new_file="\$(ls -1t ~/Desktop/Screen\ Shot*.png | head -1)"

        if [ -n "\$new_file" ]; then
          dir="\$(date +%Y-%m)"
          mkdir -p ~/Dropbox/Public/Screenshots/\$dir
          mv "\$new_file" ~/Dropbox/Public/Screenshots/\$dir
          url="https://dl.dropboxusercontent.com/u/$DROPBOXID/Screenshots/\$dir/\$(basename "\$new_file")"
          echo "\$url" | sed 's/ /%20/g' | pbcopy
PLIST
terminal_notifier
cat <<PLIST
        fi
      </string>
    </array>
  </dict>
</plist>
PLIST
} > $plist_destination

launchctl unload $plist_destination
launchctl load $plist_destination

echo "Loaded $plist_destination"
