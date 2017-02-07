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
        Gtk.Box mainContainer = new Box(Orientation.VERTICAL, 0);

        // Contains options
        Gtk.Box optionsContainer = new Box(Orientation.VERTICAL, 0);

        // Close button
        Button closeButton = new Button.with_label("Hide");

        // Wallpaper label
        Label wallpaperLabel = new Label("Wallpaper:");

        // Wallpapers list
        Gtk.ComboBoxText wallpapersComboBox = new Gtk.ComboBoxText ();


        // Triggered when pointer leaves window
        bool canDestroy = false;


        /* Add some style */
        string CSS = "*{
                        
                         border-radius: 10px;
                       }";



        public PreferencesWindow () {

            title = "";
            set_size_request(250, 250);
            resizable = false;
            window_position = WindowPosition.CENTER;
            set_titlebar(headerBar);
            // ApplyCSS({this}, CSS);
            AddAlpha({this});

            // Setup Widgets
            loadWallpapers();


            // Properties
            closeButton.margin_top = 6;
            closeButton.margin_left = 6;

            optionsContainer.margin_top = 10;
            optionsContainer.halign = Align.CENTER;

            wallpaperLabel.halign = Align.START;
            closeButton.halign = Align.START;

            // Signals
            motion_notify_event.connect(() => {

                canDestroy = false;
                
                return false;
            });

            leave_notify_event.connect(() => {

                canDestroy = true;

                return false;
            });

            focus_out_event.connect(() => {

                // if(canDestroy)
                    // destroy(); // Bye!
                return false;
            });


            wallpapersComboBox.changed.connect (() => {

                string activeWallpaper = wallpapersComboBox.get_active_text ().replace(" ", "_");

                // Update Komorebi.prop
                var configFilePath = Environment.get_home_dir() + "/.Komorebi.prop";
                var configFile = File.new_for_path(configFilePath);
                var keyFile = new KeyFile ();

                keyFile.load_from_file(@"$configFilePath", KeyFileFlags.NONE);
                keyFile.set_string  ("KomorebiProperies", "BackgroundName", activeWallpaper);


                // Delete the file
                configFile.delete();

                // save the key file
                var stream = new DataOutputStream (configFile.create (0));
                stream.put_string (keyFile.to_data ());
                stream.close ();



            });

            // Add Widgets
            headerBar.add(closeButton);
            optionsContainer.add(new Image.from_file("/System/Resources/Komorebi/komorebi.svg"));
            optionsContainer.add(wallpaperLabel);
            optionsContainer.add(wallpapersComboBox);


            add(optionsContainer);

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


            // Set active wallpaper
            wallpapersComboBox.set_title("SHIT");

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
