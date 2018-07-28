<p align="center"><img src="https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/komorebi-icon.png" width="130"></p>
<h2 align="center">Komorebi - Linux Desktop Manager</h2>
<p align="center">(n) sunlight filtering through trees.</p>



<p align="center">
	<a href="http://www.kernel.org"><img alt="Platform (GNU/Linux)" src="https://img.shields.io/badge/platform-GNU/Linux-blue.svg"></a>
	<a href="https://github.com/sindresorhus/awesome"><img alt="Awesome" src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg"></a>
	<a href="https://travis-ci.org/iabem97/komorebi"><img alt="Build Status" src="https://travis-ci.org/phw/peek.svg?branch=master"></a>
</p>

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=NvfRy5qMsos
" target="_blank"><img src="http://img.youtube.com/vi/NvfRy5qMsos/0.jpg" 
alt="Komorebi Demo" width="240" height="180" border="10" /><br>Watch demo</a>
</p>

## What is Komorebi?

Komorebi is an awesome desktop manager for all Linux platforms.
It provides fully customizeable image and video wallpapers that can be tweaked at any time!

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/collage.jpg)


## How do I install Komorebi?

Two ways:

### Packaged install (easy)

1. Download `Komorebi` from the [Komorebi releases page](https://github.com/iabem97/komorebi/releases).
2. Install Komorebi using your favorite package installer (aka. double click on it)
3. Launch Komorebi!

### Manual Installing (advanced)

1. Run the following:
```
sudo add-apt-repository ppa:gnome3-team/gnome3 -y
sudo add-apt-repository ppa:vala-team -y
sudo add-apt-repository ppa:gnome3-team/gnome3-staging -y
sudo apt install cmake valac libgtk-3-dev libgtop2-dev libgee-0.8-dev libclutter-gtk-1.0-dev libclutter-1.0-dev libclutter-gst-3.0-dev
```
2. `git clone https://github.com/iabem97/komorebi.git`
3. `cd komorebi`
4. `mkdir build && cd build`
5. `cmake .. && sudo make install && ./komorebi`

## Change Wallpaper & Desktop Preferences
To change desktop preferences or your wallpaper, right click anywhere on the desktop to show the menu.

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/preferences.jpg)

## How do I create my own wallpaper?

Komorebi provides a simple tool to create your own wallpapers! Simply, open your apps and search for 'Wallpaper Creator'

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/wallpaper_creator.jpg)

You can create either an image or a video wallpaper and you have many different options to customize your very own wallpaper!

## Uninstall

### If you installed a packaged version of Komorebi

1. Open Terminal
2. `sudo apt remove komorebi`

### If you manually installed Komorebi

1. Open Terminal
2. `cd komorebi/build`
3. `sudo make uninstall`

## Having issues?

### After uninstalling, my desktop isn't working right (blank or no icons)

The latest Komorebi should already have a fix for this issue. If you've already uninstalled Komorebi and would like to fix the issue, simply run this (in the Terminal):
`curl -s https://raw.githubusercontent.com/iabem97/komorebi/master/data/Other/postrm | bash -s`

If your issue has not already been reported, please report it *[`here`](https://github.com/iabem97/komorebi/issues/new)* and I'll try my best to fix them.

## Credits:

Komorebi is made by Abraham Masri ([@cheesecakeufo](https://twitter.com/cheesecakeufo))

### Thanks To:

Pete Lewis ([@PJayB](https://github.com/PJayB)) for adding mult-monitor support
