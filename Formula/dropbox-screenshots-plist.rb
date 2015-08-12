class DropboxScreenshotsPlist < Formula
  url "https://raw.githubusercontent.com/itspriddle/dropbox-screenshots-plist/master/Formula/dropbox-screenshots-plist.rb"
  version "HEAD"

  option "with-terminal-notifier", "Adds support for terminal-notifier"

  depends_on "terminal-notifier" if build.with? "terminal-notifier"

  def install
    unless ENV.has_key? "DROPBOXID"
      raise <<-MSG.undent
        You must specify a DROPBOXID when installing this brew.
        Eg: `DROPBOXID=12345 brew install dropbox-screenshots-plist`
      MSG
    end
  end

  def plist; <<-PLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WatchPaths</key>
        <array>
          <string>#{ENV["HOME"]}/Desktop</string>
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
            new_file="$(ls -1t ~/Desktop/Screen\\ Shot*.png | head -1)"

            if [ -n "$new_file" ]; then
              dir="$(date +%Y-%m)"
              mkdir -p ~/Dropbox/Public/Screenshots/$dir
              mv "$new_file" ~/Dropbox/Public/Screenshots/$dir
              url="https://dl.dropboxusercontent.com/u/#{ENV["DROPBOXID"]}/Screenshots/$dir/$(basename "$new_file")"
              echo "$url" | sed 's/ /%20/g' | pbcopy
              #{terminal_notifier}
            fi
          </string>
        </array>
      </dict>
    </plist>
    PLIST
  end

  private

  def terminal_notifier
    if build.with? "terminal-notifier"
      [
        "#{Formula["terminal-notifier"].opt_bin}/terminal-notifier",
        '-title "Copied Public Link to Clipboard"',
        '-message "$url"',
        '-execute "open \"$url\""'
      ].join(" ")
    end
  end
end
