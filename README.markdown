# dropbox-screenshots-plist

This is a
[launchd.plist](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html#//apple_ref/doc/man/5/launchd.plist)
for moving screenshots to Dropbox and copying the public URL.

In 2013 Dropbox added the ability to [save your screenshots in
Dropbox](https://blogs.dropbox.com/dropbox/2013/09/save-your-screenshots-in-dropbox/)
This is an awesome feature that I've used almost daily since it was announced.

One problem with this feature is that the URL copied to your clipboard is for
an HTML landing page like
<https://www.dropbox.com/s/nswq8n8jd5w2f9w/Screenshot%202015-08-11%2000.06.19.png?dl=0>.
This makes it difficult to paste directly into places like GitHub Issues that
need a real image URL.

Another issue I've had is after using this feature for 2.5 years, my
`~/Dropbox/Screenshots` directory has around 1000 files in it, making it
difficult to browse in Finder or upload file dialogs.

This plist is meant to replace Dropbox's screenshot sharing feature. It
watches for new screenshots created in `~/Desktop` (the default on OS X), and
moves them to `~/Dropbox/Public/Screenshots/YYYY-MM` (where YYYY is the
current 4-digit year and MM is the current 2-digit month). A public URL is
copied to your clipboard and can be pasted directly into GitHub Issues or
elsewhere, eg:
<https://dl.dropboxusercontent.com/u/12345/Screenshots/2015-08/Screen%20Shot%202015-08-10%20at%204.33.28%20PM.png>

## Prerequisites

1. You need a [Dropbox Public Folder](https://www.dropbox.com/help/16). If you
   have an account created before October 4, 2012, you should already have
   one. If your account was created after this date, you need a Pro or
   Business account to enable a Public folder. If you should have a Public
   folder and don't see it, you can enable it
   [here](https://www.dropbox.com/enable_public_folder).

2. Disable the Dropbox screenshot sharing feature. Option+Click on the Dropbox
   icon in the OS X menubar and click Preferences. Click the Import tab, then
   uncheck "Share screenshots using Dropbox".

3. Find your Dropbox user ID. This can be done by copying the URL to a file
   under `~/Dropbox/Public` via Finder and grabbing the `/u/DROPBOXID` section
   of the URL (see [this super user
   post](http://superuser.com/questions/61859/how-to-find-my-dropbox-database-id)).

## Installation

**Homebrew installation**

```
$ DROPBOX_ID=12345 brew install --HEAD itspriddle/brews/dropbox-screenshots-plist [--with-terminal-notifier]
$ ln -sfv $(brew --prefix)/opt/dropbox-screenshots-plist/*.plist ~/Library/LaunchAgents
$ launchctl load ~/Library/LaunchAgents/net.nevercraft.dropbox-screenshots.plist
```

**Manual installation**

```
$ git clone https://github.com/itspriddle/dropbox-screenshots-plist.git
$ cd dropbox-screenshots-plist
$ DROPBOX_ID=12345 rake install
$ launchctl load ~/Library/LaunchAgents/net.nevercraft.dropbox-screenshots.plist
```

By default the plist will use
[terminal-notifier](https://github.com/julienXX/terminal-notifier) if it is
installed (`brew install terminal-notifier` to install). Clicking the
notification will open the URL in your browser. To disable notifications
install with the `NO_TERMINAL_NOTIFIER` flag:

```
$ NO_TERMINAL_NOTIFIER=1 DROPBOX_ID=12345 rake install
```

## Uninstalling

To uninstall:

```
$ launchctl unload ~/Library/LaunchAgents/net.nevercraft.dropbox-screenshots.plist
$ rm ~/Library/LaunchAgents/net.nevercraft.dropbox-screenshots.plist
```

## Contributing

1. Fork it (https://github.com/itspriddle/dropbox-screenshots-plist/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
