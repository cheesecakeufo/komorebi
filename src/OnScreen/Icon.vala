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
        string DesktopPath = "";

        /* Path of executable path */
        public string execPath = "";

        /* Title of the file */
        public string TitleName = "";

        /* The button */
        public Button _Button = new Button();

        public Box _Box = new Box(Orientation.VERTICAL, 0);

        public Label Title = new Label(null);

        Image Icon;

        /* Wether the path is executable */
        bool IsExecutable = false;

        /* Wether this item is temporary */
        bool IsTemp = false;


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
                         font:7px Menlo;
                       }

                       *:focus {
                         transition: 50ms ease-out;
                         border-style: outset;
                         background-color: rgba(0, 0, 0, 0.3);

                        }";

            add_events(EventMask.BUTTON_PRESS_MASK);
            set_halign(Align.START);
            set_valign(Align.CENTER);
            margin = 7;

            _Button.add(_Box);
            add(_Button);



        }

        public Icon (string name, Pixbuf icon, string execPath, string desktopPath, bool IsExec = false) {

            DesktopPath = desktopPath;
            this.execPath = execPath;
            TitleName = name;
            IsExecutable = IsExec;

            Icon = new Image.from_pixbuf(icon);

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


            _Box.pack_start(Icon);
            _Box.pack_end(Title);



            /* Signals */
            _Button.button_press_event.connect((e) => {


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

                    var popover = new Popover(this);
                    var stack = new Stack();
                    var deleteButton = new Gtk.Button.with_label("Delete");

                    // A box that contains label and the horizontal box
                    var vbox = new Box(Orientation.VERTICAL, 0);

                    // A box that contains delete and cancel buttons
                    var hbox = new Box(Orientation.HORIZONTAL, 0);

                    var confirmDeletebutton = new Gtk.Button.with_label("Yes");
                    var cancelbutton = new Gtk.Button.with_label("Cancel");

                    applyCSS({popover}, "* { padding: 10px 10px 10px 10px; }");
                    popover.set_position(PositionType.RIGHT);
                    
                    hbox.halign = Align.CENTER;

                    stack.set_transition_duration(100);
                    stack.set_transition_type(StackTransitionType.OVER_UP);

                    deleteButton.released.connect(() => {

                        stack.set_visible_child(vbox);
                    });


                    confirmDeletebutton.released.connect(() => {

                        popover.destroy();
                        hide();

                        Timeout.add(2, () => {
                            var file = File.new_for_path(desktopPath);
                            
                            // Check if the file is a directory
                            if(file.query_file_type (GLib.FileQueryInfoFlags.NONE, null) == GLib.FileType.DIRECTORY) {
                                Process.spawn_command_line_async("rm -rf " + desktopPath);
                            } else
                                file.delete();

                            return false;
                        });
                    });

                    cancelbutton.released.connect(() => {

                        popover.destroy();

                    });

                    hbox.add(confirmDeletebutton);
                    hbox.add(cancelbutton);

                    vbox.add(new Label("Delete permanently?"));
                    vbox.add(hbox);

                    stack.add_named(deleteButton, "deleteButton");
                    stack.add_named(vbox, "deleteBox");

                    popover.add(stack);

                    popover.show_all();


                }



                return false;
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
