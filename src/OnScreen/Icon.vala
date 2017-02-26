//  
//  Copyright (C) 2012-2017 Abraham Masri
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
using GLib.Environment;

namespace Komorebi.OnScreen {

    public class Icon : EventBox {

        /* Add some style */
        string CSS = "";

        string EntryCSS = "*{
                         background-color: @transparent;
                         background-image: linear-gradient(to bottom,
                                           alpha(white, 0) 60%,
                                           alpha(white, 0.2));
                         border: 1px;
                         border-color: white;
                         box-shadow: inset 1px 2px rgba(0,0,0,0); 
                         border-radius: 5px;
                         color: white;
                         font:10px OpenSans Bold;
                       }";

        /* Path of the file */
        string filePath = "";

        /* Path of executable path */
        public string execPath = "";

        /* Title of the file */
        public string TitleName = "";

        /* The button */
        public Button _Button = new Button();

        public Box _Box = new Box(Orientation.VERTICAL, 0);

        public Label Title = new Label(null);

        Image Icon;

        // Right click menu with its items
        Gtk.Menu rightClickMenu = new Gtk.Menu();
        Gtk.MenuItem openMenuItem = new Gtk.MenuItem.with_label ("Open");
        Gtk.MenuItem moveToTrashMenuItem = new Gtk.MenuItem.with_label ("Move to Trash");
        Gtk.MenuItem copyMenuItem = new Gtk.MenuItem.with_label ("Copy");
        Gtk.MenuItem makeAliasMenuItem = new Gtk.MenuItem.with_label ("Make Alias");
        Gtk.MenuItem getInfoMenuItem = new Gtk.MenuItem.with_label ("Get Info");


        /* Wether the path is executable */
        bool IsExecutable = false;

        /* Wether this item is temporary */
        bool IsTemp = false;

        string desktopPath = Environment.get_user_special_dir(UserDirectory.DESKTOP);

        construct {

            /* Setup */

            CSS = @"*, *:insensitive {
                         transition: 150ms ease-in;

                         background-color: @transparent;
                         background-image: none;
                         border: none;
                         border-color: @transparent;
                         box-shadow: inset 1px 2px rgba(0,0,0,0); 
                         border-radius: 3px;
                         color: white;
                         text-shadow:2px 2px 4px rgba(0, 0, 0, 0.4);
                         icon-shadow: 0px 1px 4px rgba(0, 0, 0, 0.4);
                         font:7px Lato;
                       }

                       *:focus {
                         transition: 50ms ease-out;
                         border-style: outset;
                         background-color: rgba(0, 0, 0, 0.3);

                        }";

            // add_events (Gdk.EventMask.ALL_EVENTS_MASK);

            set_halign(Align.START);
            set_valign(Align.CENTER);
            margin = 7;

            _Button.add(_Box);
            add(_Button);



        }

        public Icon (string name, Pixbuf icon, string execPath, string filePath, bool IsExec = false) {

            filePath = filePath;
            this.execPath = execPath;
            TitleName = name;
            IsExecutable = IsExec;

            // Setup widgets
            Icon = new Image.from_pixbuf(icon);
            copyMenuItem.set_label(@"Copy \"$(TitleName)\" ");


            // Properties
            set_size_request(100, 100);
            halign = Align.CENTER;

            Title.margin_top = 10;
            Title.set_line_wrap(true);
            Title.set_max_width_chars(10);
            Title.set_ellipsize(Pango.EllipsizeMode.END);
            Title.set_halign(Align.CENTER);

            Icon.set_halign(Align.CENTER);


            applyCSS({_Button, Title, Icon}, CSS);
            Title.label = TitleName;


            // Add widgets
            rightClickMenu.append(openMenuItem);
            rightClickMenu.append(new SeparatorMenuItem());
            rightClickMenu.append(moveToTrashMenuItem);
            rightClickMenu.append(new SeparatorMenuItem());
            rightClickMenu.append(copyMenuItem);
            rightClickMenu.append(makeAliasMenuItem);
            rightClickMenu.append(getInfoMenuItem);

            _Box.pack_start(Icon);
            _Box.pack_end(Title);


            /* Signals */
            button_release_event.connect((e) => {


                if(e.button == 1) {

                    if(e.type == Gdk.EventType.@2BUTTON_PRESS) {

                        // background.grab_focus();

                        /* Open home folder */
                        // if(IsExecutable)
                        //     busserver.StartCommand(execPath);
                        // else
                        //     AppInfo.launch_default_for_uri (@"file://$DesktopPath", null);

                    }

                } else if(e.button == 3) { // Show the menu

                    rightClickMenu.show_all();

                    rightClickMenu.popup(null, null, null, e.button, e.time);

                }

                return true;
            });


            openMenuItem.activate.connect(() => {

                // Open the file/folder

            });

            moveToTrashMenuItem.activate.connect(() => {

                // Move file/folder to trash

            });

            copyMenuItem.activate.connect(() => {

                // Copy file/folder
                clipboard.set_text(filePath, filePath.length);
                clipboard.store();

            });  


            makeAliasMenuItem.activate.connect(() => {

                // Makes an alias to the file/folder
                var sourceFile = File.new_for_path(filePath);
                var sourceFileName = sourceFile.get_basename();

                var targetFile = File.new_for_path(desktopPath + "/(Alias) " + sourceFileName);

                targetFile.make_symbolic_link(filePath);

            });


 
        }
  
        /* TAKEN FROM ACIS --- Until Acis is public */
        /* Applies CSS theming for specified GTK+ Widget */
        public void applyCSS (Widget[] widgets, string CSS) {

            var Provider = new Gtk.CssProvider ();
            Provider.load_from_data (CSS, -1);

            foreach(var widget in widgets)
                widget.get_style_context().add_provider(Provider,-1);

        }
    }
}
