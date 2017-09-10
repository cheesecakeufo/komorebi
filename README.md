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

1. You need `libgtop2-dev, libgtk-3-dev, gtk+-3.0 libgtop-2.0 glib-2.0>=2.38 gee-0.8 libwnck-3.0 clutter-gtk-1.0 clutter-1.0 clutter-gst-3.0 cmake valac`
1. `git clone https://github.com/iabem97/komorebi.git`
2. `cd komorebi`
3. `mkdir build && cd build`
4. `cmake .. && sudo make install && ./komorebi`

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

If your issue is not listed above, please report it *[`here`](https://github.com/iabem97/komorebi/issues/new)* and I'll try my best to fix them.
