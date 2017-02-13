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

namespace Komorebi {

    BackgroundWindow backgroundWindow;

    /* Whether to debug or not */
    bool Debug = false;

    public static void ManageOutput (string? d, LogLevelFlags flags, string msg) {

        // switch (flags) {

        //     case LogLevelFlags.LEVEL_ERROR:
        //         //LogEvent (msg, true);
        //         break;
            
        //     case LogLevelFlags.LEVEL_INFO:
        //     case LogLevelFlags.LEVEL_CRITICAL:
        //     case LogLevelFlags.LEVEL_MESSAGE:
        //     case LogLevelFlags.LEVEL_DEBUG:
        //     case LogLevelFlags.LEVEL_WARNING:
        //         if(Debug)
        //             //LogEvent (msg, false);
        //     break;

        //     default:
        //         //LogEvent (msg, false);
        //         break;
        // }


    }

    public static void main (string [] args) {
        
        // TODO: Update after Acis is out
        /* Be nice to log-watchers */
        // PrintWelcome("Komorebi", COLOR.Red);
        print("Welcome to Komorebi\n");

        // Setup our output text shape
        if(args[1] == "--debug" || args[1] == "debug")
            Debug = true;

        if(args[1] == "--version" || args[1] == "version") {
            print("Version: 0.1 - Summit\nCreated by: Abraham Masri\n\n");
            return;
        }

        // TODO: Update after Acis is out
        //Log.set_default_handler(ManageOutput);


        Gtk.init (ref args);

        Gtk.Settings.get_default().gtk_application_prefer_dark_theme = true;

        backgroundWindow = new BackgroundWindow();
        backgroundWindow.fadeIn();

        // TODO: Update after Acis is out
        // GtkMain(false);
        Gtk.main();

        return;
    }
}
