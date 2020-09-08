<p align="center"><img src="https://raw.githubusercontent.com/Komorebi-Fork/komorebi/master/screenshots/komorebi-icon.png" width="130"></p>
<h2 align="center">Komorebi - Animated Wallpapers for Linux</h2>
<p align="center">(n) sunlight filtering through trees.</p>



<p align="center">
	<a href="http://www.kernel.org"><img alt="Platform (GNU/Linux)" src="https://img.shields.io/badge/platform-GNU/Linux-blue.svg"></a>
	<a href="https://travis-ci.org/Komorebi-Fork/komorebi"><img alt="Build Status" src="https://travis-ci.org/Komorebi-Fork/komorebi.svg?branch=master"></a>
</p>

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=NvfRy5qMsos
" target="_blank"><img src="http://img.youtube.com/vi/NvfRy5qMsos/0.jpg"
alt="Komorebi Demo" width="240" height="180" border="10" /><br>Watch demo</a>
</p>

## What is Komorebi?

Komorebi is an animated wallpaper manager for all Linux platforms.
It provides you with fully customisable image, video, and web page wallpapers that you can tweak at any time!

This project is a fork of the original [Komorebi](https://github.com/cheesecakeufo/komorebi) by [@cheesecakeufo](https://github.com/cheesecakeufo).

![s1](https://raw.githubusercontent.com/Komorebi-Fork/komorebi/master/screenshots/collage.jpg)

## Installing

Komorebi has been tested on:

- **Ubuntu** _18.04_, _20.04_
- **Elementary OS** _5.1.4_
- **Pop! OS** _20.04_
- **Fedora** _32_
- **Manjaro** _20.0.3_
- **Deepin** _20_
- **Arch Linux**
- **Gentoo**

### Debian and derivatives (Ubuntu, Deepin, Elementary OS, Pop! OS, etc...)

Download the latest `.deb` package from our [releases page](https://github.com/Komorebi-Fork/komorebi/releases/) and install it with:

```bash

sudo dpkg -i komorebi_2.2.0-1.deb
```

*(or by double-clicking on the downloaded file.)*

If you'd like to compile Komorebi from source instead, you'll need to install the following dependencies:

```bash
sudo apt install meson valac libgtk-3-dev libgee-0.8-dev libclutter-gtk-1.0-dev libclutter-1.0-dev libwebkit2gtk-4.0-dev libclutter-gst-3.0-dev
```

and jump to the [compiling section](#compiling).

### Fedora / OpenSUSE

**Fedora uses Wayland by default, which Komorebi doesn't support yet. You will have to switch to Xorg for the meantime.**

Grab the appropriate rpm from [here](https://build.opensuse.org/package/show/home%3ANNowakowski/Komorebi-Fork), and install it.

```bash
sudo rpm -ivh komorebi-2.2.0-9.1.x86_64.rpm
```

If you'd like to compile Komorebi from source instead, you'll need to install the following dependencies:

```bash
sudo dnf install meson vala gcc-c++ gtk3-devel clutter-devel clutter-gtk-devel clutter-gst3-devel webkit2gtk3-devel libgee-devel gstreamer1-libav
```

and jump to the [compiling section](#compiling).

### Arch Linux and derivatives (Manjaro, etc...)

Install from the [AUR](https://aur.archlinux.org/packages/komorebi/):

```bash
yay -S komorebi
```

or grab the required dependencies:

```bash
sudo pacman -S meson vala gtk3 clutter clutter-gtk clutter-gst libgee
```

and jump to the [compiling section](#compiling).

## Compiling

Run the following:

```bash
git clone https://github.com/Komorebi-Fork/komorebi.git
cd komorebi
meson build && cd build && meson compile
```

To install the compiled package:

```bash
meson install
```

## Using Komorebi

Simply run `komorebi`, or open your application launcher and look for **Komorebi**.

Komorebi displays behind all other windows, so you may not notice anything if you have a fullscreen application running.

Optional arguments:

- `--single-screen`: forces Komorebi to run on the main screen only
- `version` or `--version`: prints current version

### Change wallpaper & desktop preferences

Komorebi's preferences (including the wallpaper selector) can be accessed from the bubble menu, available by right-clicking on the desktop.

![s1](https://raw.githubusercontent.com/Komorebi-Fork/komorebi/master/screenshots/preferences.jpg)

### Create custom wallpapers

Komorebi provides a simple tool to create your own wallpapers! Simply run `komorebi-wallpaper-creator` or open your application launcher and search for **Wallpaper Creator**.

![s1](https://raw.githubusercontent.com/Komorebi-Fork/komorebi/master/screenshots/wallpaper_creator.jpg)

You can use either an image, a video, or a web page as a wallpaper and you have many different options to customize your very own wallpaper!

## Uninstalling

If you manually installed Komorebi, run the following on the cloned repository folder:

```bash
cd build
sudo ninja uninstall
```

If you didn't compile Komorebi from source, you can uninstall it through your package manager in the same way you would uninstall any other package.

## Questions? Issues?

### Komorebi is slow. What can I do about it?

Komorebi includes support for video wallpapers that might slow your computer down. We've put together a few tips that you can use to increase performance on the [wiki](https://github.com/Komorebi-Fork/komorebi/wiki/Improve-video-wallpapers-performance).

You can also disable support for video wallpapers altogether in 'Desktop Preferences' → uncheck 'Enable Video Wallpapers'.

_note: you need to quit and re-open Komorebi after changing this option_

### Komorebi is crashing and I'm using two or more screens!

This is a [known bug](https://github.com/Komorebi-Fork/komorebi/issues/18). There's currently no solution for this, but if you have any ideas we'd love to hear from you!

For now, you can force Komorebi to display on the main screen only by running it with `--single-screen`.

### After uninstalling, my desktop isn't working right (blank or no icons)

The latest version should already have a fix for this issue. If you've already uninstalled Komorebi and would like to fix the issue, simply run this (in the Terminal):
`curl -s https://raw.githubusercontent.com/Komorebi-Fork/komorebi/master/data/Other/postrm | bash -s`

If your issue has not already been reported, please report it [here](https://github.com/Komorebi-Fork/komorebi/issues/new).

### Thanks To:

Pete Lewis ([@PJayB](https://github.com/PJayB)) for adding multi-monitor support
