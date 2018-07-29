//
//  Copyright (C) 2017-2018 Abraham Masri @cheesecakeufo
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
// Copied from ManagerForKedos - Abraham Masri
//

using Gtk;
using Gdk;
using GtkClutter;
using GLib.Environment;

using Komorebi.Utilities;

namespace Komorebi.OnScreen {

    public enum IconType {
        NORMAL,
        EDIT,
        TRASH
    }

    public class Icon : Clutter.Actor {

        DesktopIcons parent;

        /* Path of the file */
        public string filePath = "";

        /* Path of executable path */
        public string execPath = "";

        /* Title of the file */
        public string titleName = "";

        Clutter.BoxLayout boxLayout = new Clutter.BoxLayout() {orientation = Clutter.Orientation.VERTICAL};

        Clutter.Actor mainActor = new Clutter.Actor();
        Clutter.Actor iconActor = new Clutter.Actor();
        Clutter.Image iconImage = new Clutter.Image();
        Clutter.Text titleText = new Clutter.Text();

        // Ability to drag
        Clutter.DragAction dragAction = new Clutter.DragAction();

        // Wether the path is executable
        bool isExecutable = false;

        // Type of this icon
        IconType iconType;


        construct {

            // Properties
            layout_manager = boxLayout;
            reactive = true;
            height = 83;
            opacity = 0;

            set_pivot_point (0.5f, 0.5f);

            iconActor.set_size(iconSize, iconSize);

            titleText.set_line_wrap(true);
            titleText.set_max_length(10);
            titleText.ellipsize = Pango.EllipsizeMode.END;

            setupSignals();

            // Add widgets
            iconActor.add_action(dragAction);

            iconActor.set_content(iconImage);
            add_child(iconActor);
            add_child(titleText);

        }

        public Icon (DesktopIcons parent, string name, Pixbuf pixbuf, string execPath, string filePath,
                     bool isExecutable = false) {
            this.parent = parent;
            this.filePath = filePath;
            this.execPath = execPath;
            this.titleName = name;
            this.isExecutable = isExecutable;
            this.iconType = IconType.NORMAL;

            // Setup widgets
            iconImage.set_data (pixbuf.get_pixels(),
                                pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                                iconSize, iconSize,
                                pixbuf.get_rowstride());

            titleText.set_markup(@"<span color='white' font='Lato Bold 11'>$titleName</span>");

        }

        public Icon.Trash (DesktopIcons parent) {
            this.parent = parent;
            this.titleName = "Trash";
            var pixbuf = Utilities.getIconFrom("user-trash", 64);

            iconImage.set_data (pixbuf.get_pixels(),
                                pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                                iconSize, iconSize,
                                pixbuf.get_rowstride());

            titleText.set_markup(@"<span color='white' font='Lato Bold 11'>Trash</span>");

            this.iconType = IconType.TRASH;

        }

        public Icon.NewFolder (DesktopIcons parent) {
            this.parent = parent;

            var pixbuf = Utilities.getIconFrom("folder", 64);

            iconImage.set_data (pixbuf.get_pixels(),
                                pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                                iconSize, iconSize,
                                pixbuf.get_rowstride());

            this.iconType = IconType.EDIT;
            /*mainBox.add(entry);*/

            /*entry.grab_focus();*/
        }

        /* Setup all signals */
        private void setupSignals () {

            button_press_event.connect((e) => {

                // We don't show animations when right-click button is pressed
                if (e.button != 3) {
                    scaledScale();
                }


                return true;
            });

            button_release_event.connect ((e) => {

                if(!showDesktopIcons)
                    return true;

                save_easing_state ();
                set_easing_duration (90);
                scale_x = 1.0f;
                scale_y = 1.0f;
                set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
                restore_easing_state ();

                switch(iconType) {

                    case IconType.NORMAL:

                        if(e.button == 1) {

                            // TODO: Replace event with 2BUTTON_PRESS
                            AppInfo.launch_default_for_uri (@"file://$filePath", null);

                        } else if(e.button == 3) { // Show the menu
                            BackgroundWindow backgroundWindow = parent.window;
                            BubbleMenu bubbleMenu = backgroundWindow.bubbleMenu;

                            backgroundWindow.dimWallpaper();

                            bubbleMenu.fadeIn(e.x, e.y, MenuType.ICON);
                            bubbleMenu.setIcon(this);

                            // Dim our text
                            titleText.opacity = 50;

                            // Dim other icons
                            foreach (var icon in parent.iconsList) {
                                if(icon.filePath != this.filePath)
                                    icon.dimIcon();
                            }


                        }
                    break;

                    case IconType.TRASH:

                        // TODO: Replace event with 2BUTTON_PRESS
                        AppInfo.launch_default_for_uri ("trash://", null);
                    break;

                }


                return true;
            });
/*
            entry.key_release_event.connect((e) => {

                switch (e.keyval) {

                    case Gdk.Key.Return:
                    case Gdk.Key.KP_Enter:
                        mainBox.remove(entry);
                        buttonBox.pack_end(title);

                        if(entry.text == "")
                            titleName = "New Folder";
                        else
                            this.titleName = entry.text;
                        copyMenuItem.set_label(@"Copy \"$(titleName)\" ");
                        titleText.set_markup(@"<span color='white' font='Lato Bold 11'>$titleName</span>");
                        title.set_markup(@"<span color='white' font='Lato Bold 11'>$titleName</span>");
                        title.show_all();

                        // Set the type of the icon back to normal
                        this.iconType = IconType.NORMAL;

                        // Create an actual folder
                        createNewFolder(titleName);

                    break;

                    case Gdk.Key.Menu:
                        entry.grab_focus();
                    break;
                }

                return false;
            });


            makeAliasMenuItem.activate.connect(() => {

                // Makes an alias to the file/folder
                var sourceFile = File.new_for_path(filePath);
                var sourceFileName = sourceFile.get_basename();
                var targetFile = File.new_for_path(desktopPath + "/(Alias) " + sourceFileName);

                targetFile.make_symbolic_link(filePath);
            });*/


        }

        /* Restores icon's scale to scaled down */
        private bool scaledScale () {

            save_easing_state ();
            set_easing_duration (90);
            scale_x = 0.9f;
            scale_y = 0.9f;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

            return true;
        }

        /* Trashes the icon */
        public void trash () {

            save_easing_state ();
            set_easing_duration (90);
            scale_x = 0.9f;
            scale_y = 0.9f;
            opacity = 0;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

        }

        public bool dimIcon () {

            save_easing_state ();
            set_easing_duration (400);
            opacity = 100;
            titleText.opacity = 100;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

            return true;
        }

        public bool unDimIcon (bool with_scale = false) {

            if(with_scale) {
                scale_y = 0.5f;
                scale_x = 0.5f;
            }

            save_easing_state ();
            set_easing_duration (400);
            opacity = 255;
            if(with_scale) {
                scale_y = 1.0f;
                scale_x = 1.0f;
            }
            titleText.opacity = 255;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();
            return true;
        }

        /* Activates rename mode */
        public void activateRenameMode () {


        }

    }
}
