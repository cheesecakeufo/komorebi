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


using Gtk;
using Gdk;

namespace Komorebi.OnScreen {

    public class PreferencesWindow : Gtk.Window {

        // Custom headerbar
        HeaderBar headerBar = new HeaderBar();

        /* Main container */
        Gtk.Box mainContainer = new Box(Orientation.HORIZONTAL, 10);

        // Contains options
        Gtk.Box optionsContainer = new Box(Orientation.VERTICAL, 15);

        // Contains other options (time/info box/etc..)
        Gtk.Box otherOptionsContainer = new Box(Orientation.VERTICAL, 5);

        // Show info box button
        Gtk.CheckButton showSystemStatsButton = new Gtk.CheckButton.with_label ("Show System Stats");

        // Dark info box button
        Gtk.CheckButton darkSystemStatsButton = new Gtk.CheckButton.with_label ("Dark System Stats");

        // 24 Hours time button
        Gtk.CheckButton twentyFourHoursButton = new Gtk.CheckButton.with_label ("Display time as 24-hr");

        // Optimize for memory (Beta) button
        Gtk.CheckButton optimizeForMemoryButton = new Gtk.CheckButton.with_label ("Optimize For Memory(Beta)");

        // Show Desktop Icons (Beta) button
        Gtk.CheckButton showDesktopIconsButton = new Gtk.CheckButton.with_label ("Show desktop icons(Beta)");

        // Hide button
        Button hideButton = new Button.with_label("Hide");
        
        // Quit button
        Button quitButton = new Button.with_label("Quit Komorebi");

        // Wallpaper label
        Label wallpaperLabel = new Label("Wallpaper:");

        // Wallpapers list
        Gtk.ComboBoxText wallpapersComboBox = new Gtk.ComboBoxText ();

        // Report an issue button
        Button reportButton = new Button.with_label("Report an issue");


        // Triggered when pointer leaves window
        bool canDestroy = false;


        /* Add some style */
        string CSS = "*{background-color: rgba(40, 40, 40, 0.80); box-shadow: none; color: white; border-width: 0px;}";
        string headerCSS = "*{background-color: rgba(30, 30, 30, 0.85);  box-shadow: none; color: white; border-width: 0px;}";



        public PreferencesWindow () {

            title = "";
            set_size_request(250, 250);
            resizable = false;
            window_position = WindowPosition.CENTER;
            set_titlebar(headerBar);
            ApplyCSS({this}, CSS);
            ApplyCSS({headerBar, reportButton}, headerCSS);
            AddAlpha({this});

            // Setup Widgets
            loadWallpapers();

            showSystemStatsButton.active = showInfoBox;
            darkSystemStatsButton.active = darkInfoBox;
            twentyFourHoursButton.active = timeTwentyFour;
            optimizeForMemoryButton.active = optimizeForMemory;
            showDesktopIconsButton.active = showDesktopIcons;

            // Properties
            hideButton.margin_top = 6;
            hideButton.margin_left = 6;

            quitButton.margin_top = 6;
            quitButton.margin_right = 6;

            mainContainer.margin = 10;
            optionsContainer.margin_left = 10;

            otherOptionsContainer.margin_right = 10;

            optionsContainer.halign = Align.CENTER;

            wallpaperLabel.halign = Align.START;
            reportButton.halign = Align.START;
            hideButton.halign = Align.START;

            otherOptionsContainer.valign = Align.CENTER;

            // Signals
            destroy.connect(() => {canOpenPreferences = true;});

            hideButton.released.connect(() => { destroy(); });
            quitButton.released.connect(() => { 

                print("Komorebi is going on a trip to sleep land. Good bye!\n");
                Gtk.main_quit();

            });

            wallpapersComboBox.changed.connect (() => { activeWallpaperName = wallpapersComboBox.get_active_text ().replace(" ", "_"); updateConfigurationFile(); });

            reportButton.released.connect(() => { 

                AppInfo.launch_default_for_uri("https://github.com/iabem97/komorebi/issues", null);
                destroy();

            });


            showSystemStatsButton.toggled.connect (() => { showInfoBox = showSystemStatsButton.active; updateConfigurationFile(); });
            darkSystemStatsButton.toggled.connect (() => { darkInfoBox = darkSystemStatsButton.active; updateConfigurationFile(); });
            twentyFourHoursButton.toggled.connect (() => { timeTwentyFour = twentyFourHoursButton.active; updateConfigurationFile(); });
            optimizeForMemoryButton.toggled.connect (() => { optimizeForMemory = optimizeForMemoryButton.active; updateConfigurationFile(); });
            showDesktopIconsButton.toggled.connect (() => { showDesktopIcons = showDesktopIconsButton.active; updateConfigurationFile(); });


            // Add Widgets
            headerBar.add(hideButton);
            headerBar.pack_end(quitButton);

            optionsContainer.add(new Image.from_file("/System/Resources/Komorebi/komorebi.svg"));
            optionsContainer.add(wallpaperLabel);
            optionsContainer.add(wallpapersComboBox);
            optionsContainer.add(reportButton);

            otherOptionsContainer.add(showSystemStatsButton);
            otherOptionsContainer.add(darkSystemStatsButton);
            otherOptionsContainer.add(twentyFourHoursButton);
            otherOptionsContainer.add(optimizeForMemoryButton);
            otherOptionsContainer.add(showDesktopIconsButton);

            mainContainer.add(optionsContainer);
            mainContainer.add(new Separator(Orientation.VERTICAL));
            mainContainer.add(otherOptionsContainer);

            add(mainContainer);

            show_all();
        }

        /* Loads wallpapers list and adds it to the list */
        public void loadWallpapers() {

            File wallpapersFolder = File.new_for_path("/System/Resources/Komorebi");

            try {

                var enumerator = wallpapersFolder.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);

                FileInfo info;

                while ((info = enumerator.next_file ()) != null)
                    
                    // Only bring directories in
                    if (info.get_file_type () == FileType.DIRECTORY) {
                        
                        var wallpaperName = info.get_name ();
                        wallpapersComboBox.append (wallpaperName, wallpaperName.replace("_", " "));

                        // Check if this is the active one
                        if(wallpaperName == activeWallpaperName)
                            wallpapersComboBox.set_active_id(wallpaperName);
                    }

                    

            } catch {

                print("Could not read directory '/System/Resources/Komorebi/'");

            }



        }

        /* Updates the .prop file */
        void updateConfigurationFile () {



            // Update Komorebi.prop
            var configFilePath = Environment.get_home_dir() + "/.Komorebi.prop";
            var configFile = File.new_for_path(configFilePath);
            var keyFile = new KeyFile ();

            keyFile.load_from_file(@"$configFilePath", KeyFileFlags.NONE);

            keyFile.set_string  ("KomorebiProperies", "BackgroundName", activeWallpaperName);
            keyFile.set_boolean ("KomorebiProperies", "ShowInfoBox", showInfoBox);
            keyFile.set_boolean ("KomorebiProperies", "DarkInfoBox", darkInfoBox);
            keyFile.set_boolean ("KomorebiProperies", "TimeTwentyFour", timeTwentyFour);
            keyFile.set_boolean ("KomorebiProperies", "OptimizeForMemory", optimizeForMemory);

            // Delete the file
            configFile.delete();

            // save the key file
            var stream = new DataOutputStream (configFile.create (0));
            stream.put_string (keyFile.to_data ());
            stream.close ();



        }


        /* Shows the window */
        public void FadeIn() {

            show_all();

        }

        /* TAKEN FROM ACIS --- Until Acis is public */
        /* Applies CSS theming for specified GTK+ Widget */
        public void ApplyCSS (Widget[] widgets, string CSS) {

            var Provider = new Gtk.CssProvider ();
            Provider.load_from_data (CSS, -1);

            foreach(var widget in widgets)
                widget.get_style_context().add_provider(Provider,-1);

        }

        /* TAKEN FROM ACIS --- Until Acis is public */
        /* Allow alpha layer in the window */
        public void AddAlpha (Widget[] widgets) {

            foreach(var widget in widgets)
                widget.set_visual (widget.get_screen ().get_rgba_visual () ??
                                   widget.get_screen ().get_system_visual ());

        }

    }
}
