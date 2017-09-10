//
//  Copyright (C) 2016-2017 Abraham Masri
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

using Komorebi.OnScreen;
using Komorebi.Utilities;

namespace Komorebi {

    BackgroundWindow backgroundWindow;

    public static void main (string [] args) {

        print("Welcome to Komorebi\n");

        if(args[1] == "--version" || args[1] == "version") {
            print("Version: 2.0 - Summit\nCreated by: Abraham Masri @cheesecakeufo\n\n");
            return;
        }

        disableVideo = ("--disable-video" in args);

        GtkClutter.init (ref args);
        Gtk.init (ref args);

        if(!disableVideo)
            Gst.init (ref args);

        Gtk.Settings.get_default().gtk_application_prefer_dark_theme = true;

        backgroundWindow = new BackgroundWindow();


        var mainSettings = Gtk.Settings.get_default ();
        mainSettings.set("gtk-xft-dpi", (int) (1042 * 100), null);
        mainSettings.set("gtk-xft-antialias", 1, null);
        mainSettings.set("gtk-xft-rgba" , "none", null);
        mainSettings.set("gtk-xft-hintstyle" , "slight", null);

        if(!backgroundWindow.checkDesktopCompatible()) {
            print("[ERROR]: Wayland detected. Not supported (yet) :(\n");
            print("[INFO]: Contribute to Komorebi and add the support! <3\n");
            return;
        }

        backgroundWindow.fadeIn();

        Clutter.main();
    }
}
