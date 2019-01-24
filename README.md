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

