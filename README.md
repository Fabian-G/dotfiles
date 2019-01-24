# Dotfiles

This repository contains a small collection of my dotfiles and scripts I use with them.
Note that I manage my actual production dotfiles offline and copy a selection of them
on occasion into this repository, which has the following implications for this repo:

* Bulky commits
* Unuseful commit messages
* Possibly not the newest versions

In case you find a bug in one of my script, have some trouble setting things up or have 
other comments, simply leave a message in the *issues* tab.

# Install 

You can install a package by using stow i.e. `stow --no-folding scripts`. 
Stow creates symlinks in the parent folder according to the file structure in each package.
Therefore make sure to clone this repo into your home directory or use `--target` with stow.
You want to use `--no-folding`, because this prevents stow from creating symlinks to directories, which 
might result in programmes creating cache files in the directory in which you cloned this repo, which
is usually not what you want.

Example:
* $HOME
    * dotfiles
        * i3
            * .i3
                * config
        * dunst
            * .config
                * dunst
                    * dunstrc
    * .config

`stow --no-folding i3` will create the directory `$HOME/.i3` and create the symlink `$HOME/.i3/config -> $HOME/dotfiles/i3/.i3/config`

# How To's

This sections will provide some instructions on how to set certain things up.
Note that I will provide a commit id with each how to. 
That is the id of the commit which certainly contains all the needed scripts and files
in the needed version.
Chances are however that the latest commit will work just fine.

## Playback notification with album art (Cmus) 
*commit: b4045f0*

![cmus playback notification](screenshots/cmus-playback-notification.png)

Dependencies: 
* cmus
* ffmpegthumbnailer
* xorg-xprop
* wmctrl
* Some notification daemon (works best with dunst)

To set this up simply copy [playbackstatus](scripts/bin/playbackstatus) in some folder,
which is in your `$PATH`.
After that you want to open cmus and enter `:status_display_program=playbackstatus` 
and it should work fine.

Playback status will use *ffmpegthumbnailer* to extract the album art embedded in the audio
file and cache it in `~/.cache/cmus-notify`.
In case the file doesn't have embedded album art the default icon (emblem-music-symbolic.symbolic)
is used, which must be provided by your icon theme.

By default the playbackstatus script won't show a notification if cmus is in state *stopped*,
because this would show a notification on startup. 
If you want that notification remove the corresponding if clause right at the bottom of the 
script.

Additionally you can configure this script to not show notifications if cmus is the focused
window.
This feature relies on the window title of the terminal cmus is running in.
Therefore to use this feature you must choose an appropriate window title for cmus.
I usually use(execute in cmus):
```bash
set altformat_title=Music Player: %f
set format_title=Music Player: %a - %l - %t (%y)
```
after that assign *"Music Player: "* to the `TITLE_STRING` variable in *playbackstatus*
and you are done.
