//
//  Copyright (C) 2017-2018 Abraham Masri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

using WallpaperCreator.OnScreen;

namespace WallpaperCreator {

    string filePath;
    string assetPath;
    string thumbnailPath;
    string webPageUrl;

    string wallpaperName;
    string wallpaperType; // image/video/web_page
    bool wallpaperParallax;

    // Properties
    bool showDateTime;
    bool dateTimeParallax;
    
    int marginTop;
    int marginRight;
    int marginLeft;
    int marginBottom;

    string position;
    string alignment;
    bool dateTimeAlwaysOnTop;

    string dateTimeColor;
    int dateTimeAlpha;

    string shadowColor;
    int shadowAlpha;

    string timeFont;
    string dateFont;

    bool showAsset = false;
    string animationMode;
    int animationSpeed;

    public static void main (string [] args) {

        print("Welcome to Komorebi Wallpaper Creator\n");

        if(args[1] == "--version" || args[1] == "version") {
            print("Version: 1.1 - Summit\nCreated by: Abraham Masri @cheesecakefuo\n\n");
            return;
        }
        Gtk.init (ref args);

        Gtk.Settings.get_default().gtk_application_prefer_dark_theme = true;

        new NewWallpaperWindow();

        var mainSettings = Gtk.Settings.get_default ();
        mainSettings.set("gtk-xft-antialias", 1, null);
        mainSettings.set("gtk-xft-rgba" , "none", null);
        mainSettings.set("gtk-xft-hintstyle" , "slight", null);

        Gtk.main();
    }
}
