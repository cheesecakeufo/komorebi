<p align="center"><img src="https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/komorebi-icon.png" width="160"></p>
<h1 align="center">Komorebi - Linux Wallpapers Manager</h1>
<p align="center">(n) sunlight filtering through trees.</p>


<p align="center">
	<a href="http://www.kernel.org"><img alt="Platform (GNU/Linux)" src="https://img.shields.io/badge/platform-GNU/Linux-blue.svg"></a>
	[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)
</p>

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

*View Tutorial: [`Click here`](https://github.com/iabem97/komorebi)*

### Cloudy-like wallpaper

Create a cloudy-like wallpaper (check cloudy_forest)

1. Create a new folder with your wallpaper name (e.g. my_custom_wallpaper)
2. Add your base background to your new folder and name it (bg.jpg)
3. Add your asset (the layer on top of the base background that moves like clouds), and name it (assets.png) [Make sure it has a transparent channel]
4. Copy 'config' file from cloudy_forest and paste it into your my_custom_wallpaper folder
5. Open your copied 'config' file
6. AnimationMode must be equal to 'clouds'
7. AnimationSpeed is the speed of the moving clouds
8. DateTimeBoxParallax gives the date and time labels a parallax effect
9. DateTimeBoxMargin* is the margin of the date and time labels. Very useful if you want to move the labels around.
10. DateTimeBoxHAlign is the horizontal position of the date and time labels [values: start, center, end]
11. DateTimeBoxVAlign is the vertical position of the date and time labels [values: start, center, end]
12. TimeLabelAlignment is the alignment of the date and time text [values: start, center, end]
13. DateTimeBoxOnTop indicates whether the date and time labels show ALWAYS be on top of everything [values: true, false]
14. DateTimeColor is the color value of the date and time labels [values: any color (e.g. #FFFFFF)]
15. DateTimeShadow is the shadow value of the date and time labels [values: CSS shadow (e.g. 0px 4px 3px rgba(0,0,0,0.4) )]
16. TimeLabelFont is the font and size of the time label [values: CSS font value (e.g. Ubuntu Regular 40)]
17. DateLabelFont is the font and size of the date label [values: CSS font value (e.g. Ubuntu Regular 30)]

## Screenshots

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/forest-min.png)

![s2](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/mountain-min.png)

![s3](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/sand-min.png)

![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/sunny-min.png)
