<p align="center"><img src="https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/komorebi-icon.png" width="160"></p>
<h1 align="center">How To Create And Customize Wallpapers For Komorebi</h1>


---
Making/Customizing a wallpaper for Komorebi is very easy, and can be done in minutes.

### Cloudy-like wallpaper
![s1](https://raw.githubusercontent.com/iabem97/komorebi/master/screenshots/mountain-min.png)

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

