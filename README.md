<p align="center"><img src="https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/komorebi-icon.png" width="160"></p>
<h1 align="center">Komorebi - Linux Wallpapers Manager</h1>
<p align="center">(n) sunlight filtering through trees.</p>



<p align="center">
	<a href="http://www.kernel.org"><img alt="Platform (GNU/Linux)" src="https://img.shields.io/badge/platform-GNU/Linux-blue.svg"></a>
	<a href="https://github.com/sindresorhus/awesome"><img alt="Awesome" src="https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg"></a>
	<a href="https://travis-ci.org/iabem97/komorebi"><img alt="Build Status" src="https://travis-ci.org/phw/peek.svg?branch=master"></a>
</p>

https://travis-ci.org/iabem97/komorebi.svg?branch=master
---
## What is Komorebi?
Komorebi is an awesome background manager for all Linux platforms.
It provides fully customizeable backgrounds that can be tweaked at any time!
Wallpapers included by default range from animated ones, still, and gradients!
See screenshots below.


## How to install

### Packaged install

1. Download `Komorebi` from the [Komorebi releases page](https://github.com/iabem97/komorebi/releases).
2. Install Komorebi using your favorite package installer (aka. double click on it)
3. Launch Komorebi!

### Manual Installing

1. You need libgtop2-dev, libgtk-3-dev, cmake, and valac
1. `git clone https://github.com/iabem97/komorebi.git`
2. `cd komorebi`
3. `mkdir build && cd build`
4. `cmake .. && sudo make install && ./komorebi`

## Configuration

Configuration can be done in a single file located in your home directory ~/.Komorebi.prop

1. To change the background/wallpaper, change BackgroundName's value to the name of the wallpaper you want (wallpapers are located in /System/Resources/Komorebi/)
2. To show system stats on the top, change ShowInfoBox's value to true (false if otherwise)
3. To make system stats's dark, change DarkInfoBox's value to true (false if otherwise)

## How-to create/customize a wallpaper

Making/Customizing a wallpaper for Komorebi is very easy, and can be done in minutes.

### View Tutorial: *[`Click here`](https://github.com/iabem97/komorebi/blob/master/Tutorial.md)*

## Screenshots

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/forest-min.png)

![s2](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/mountain-min.png)

![s3](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/sand-min.png)

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/sunny-min.png)
