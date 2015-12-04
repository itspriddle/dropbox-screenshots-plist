require "etc"

task :validate_dropbox_id do
  unless ENV["DROPBOX_ID"]
    abort "You must specify a DROPBOX_ID, eg: `rake DROPBOX_ID=12345`"
  end
end

task :terminal_notifier_code do
  unless ENV["NO_TERMINAL_NOTIFIER"]
    terminal_notifier_bin = ENV["TERMINAL_NOTIFIER_PATH"] || `which terminal-notifier`.chomp

    if terminal_notifier_bin != ""
      @terminal_notifier_code = [
        "#{terminal_notifier_bin}",
        '-title "Copied Public Link to Clipboard"',
        '-message "Click to view: $url"',
        '-open "$url"',
        '-sender com.getdropbox.dropbox'
      ].join(" ")
    end
  end
end

prefix = ENV["PREFIX"] || "."

# Don't use `ENV["HOME"]` since Homebrew changes it during an install
home = Etc.getpwnam(ENV["USER"]).dir

PLIST_FILE = "#{prefix}/net.nevercraft.dropbox-screenshots.plist"

task build: [:validate_dropbox_id, :terminal_notifier_code] do
  File.open PLIST_FILE, "w" do |f|
    f.write <<-PLIST.gsub(/^      /, "")
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{File.basename(PLIST_FILE, ".plist")}</string>
          <key>WatchPaths</key>
          <array>
            <string>#{home}/Desktop</string>
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
                url="https://dl.dropboxusercontent.com/u/#{ENV["DROPBOX_ID"]}/Screenshots/$dir/$(basename "${new_file// /%20}")"
                printf "%s" "$url" | pbcopy
                #{@terminal_notifier_code}
              fi
            </string>
          </array>
        </dict>
      </plist>
    PLIST
  end
end

task install: :build do
  FileUtils.cp PLIST_FILE, "#{home}/Library/LaunchAgents/#{PLIST_FILE}"
end
