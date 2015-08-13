class DropboxScreenshotsPlist < Formula
  head "https://github.com/itspriddle/dropbox-screenshots-plist.git"

  option "with-terminal-notifier", "Adds support for terminal-notifier"

  depends_on "terminal-notifier" if build.with? "terminal-notifier"

  def install
    unless ENV.has_key? "DROPBOX_ID"
      raise <<-MSG.undent
        You must specify a DROPBOX_ID when brewing this formula.
        Eg: `DROPBOX_ID=12345 brew install dropbox-screenshots-plist`
      MSG
    end

    rake_args = ["build", "DROPBOX_ID=#{ENV["DROPBOX_ID"]}", "PREFIX=#{prefix}"]

    if build.with? "terminal-notifier"
      rake_args << "TERMINAL_NOTIFIER_PATH=#{Formula["terminal-notifier"].opt_bin}/terminal-notifier"
    end

    rake *rake_args
  end
end
