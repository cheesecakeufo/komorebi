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
// 
// Copied from ManagerForKedos - Abraham Masri
// 

using Gtk;
using Gee;

using GLib.Environment;

namespace Komorebi.OnScreen {

    public class DesktopIcons : ResponsiveGrid {

        /* Desktop items holder */

        /* Desktops path */
        string DesktopPath = Environment.get_user_special_dir(UserDirectory.DESKTOP);

        /* Last items' Col & Row */
        int Row = 0;
        int Column = 0;

        /* Maximum num of DI */
        int MaxColumn = 0;

        FileMonitor Monitor;


        /* Drag and drop accepted types */
        private const Gtk.TargetEntry[] targets = {
            {"text/uri-list", 0, 0},
            {"inode/directory", 0, 0}
        };
    

        /* List of desktopItems (used to make things faster when reloading) */
        Gee.ArrayList<Icon> desktopItems = new Gee.ArrayList<Icon>();

        public DesktopIcons () {

            set_orientation(Orientation.HORIZONTAL);

            margin = 30;
            hexpand = true;
            vexpand = true;
            halign = Align.START;
            Gtk.drag_dest_set (this, Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);


            setEdgeLimit(0);
            appendType = ResponsiveGrid.Type.ROW;
            row_spacing = 5;
            // Holder.hexpand = true;
            // Holder.vexpand = true;

            /* Add widgets */
            // add(Holder);

            DetermineSize();
            MonitorChanges();

            GetDesktops();

            // Signals
            drag_data_received.connect(handleDragReceived);

        }



        /* When user drags something onto the desktop */
        private void handleDragReceived (Gdk.DragContext drag_context, int x, int y, 
                                            Gtk.SelectionData data, uint info, uint time) 
        {
            //loop through list of URIs
            foreach(string uri in data.get_uris ()) {

                // Path of the file
                string filePath = uri.replace("file://","").replace("file:/","");
                filePath = Uri.unescape_string (filePath);

                // Get the actual GLib file
                var file = File.new_for_path(filePath);

                // Desktop GLib file
                var desktopFile = File.new_for_path(DesktopPath + "/" + file.get_basename());

                // Check if the file is a directory or a regular file
                // if(file.query_file_type (GLib.FileQueryInfoFlags.NONE, null) == FileType.DIRECTORY) 
                //     Acis.copyFolder(file, desktopFile);
                // else
                //     file.copy(desktopFile, FileCopyFlags.NONE, null);
            }

            Gtk.drag_finish (drag_context, true, false, time);
        }

        /* Watch for Changes */
        void MonitorChanges () {

            Monitor = File.new_for_path(DesktopPath).monitor(0);

            Monitor.changed.connect((e,a,event) => {
                if(event == FileMonitorEvent.DELETED || event == FileMonitorEvent.CREATED)
                    GetDesktops();


            });

        }


        /* Get .desktop(s) */
        public void GetDesktops () {

            clear();

            Column = 0;
            Row = 0;

            GrabDesktopPaths();

        }


        /* Async get desktop items */
        public void GrabDesktopPaths () {

            var desktopFile = File.new_for_path (DesktopPath);

            // Reads all files in the directory
            var Enum = desktopFile.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);      
            FileInfo info;

            while ((info = Enum.next_file ()) != null) {

                // Location of the file
                string FilePath = DesktopPath + "/" + info.get_name ();

                string Name = info.get_name();
                Gdk.Pixbuf IconPixbuf = null;
                var Path = FilePath;
                var DFile = File.new_for_path(FilePath);
                OnScreen.Icon _DesktopItem = null;

                /* Check if the file is .desktop */
                if(DFile.get_basename().has_suffix(".desktop")) {

                    var _KeyFile = new KeyFile();
                    _KeyFile.load_from_file(DFile.get_path(), 0);

                    Name = _KeyFile.get_string(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_NAME);

                    var Icn = _KeyFile.get_string(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_ICON);

                    IconPixbuf = Utilities.GetIconFrom(Icn, 64);

                    Path = _KeyFile.get_string(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_EXEC);


                    _DesktopItem = new Icon(Name, IconPixbuf, Path, DFile.get_path(), true);

  

                } else {

                    string IconPath = LoadIcon(DFile);

                    if(IconPath == null) {
                        if(DFile.query_file_type(FileQueryInfoFlags.NONE) == FileType.DIRECTORY)
                            IconPath = "folder";
                        else {

                            var iconQuery = DFile.query_info("standard::icon", 0).get_icon ().to_string().split(" ");
                            if(iconQuery.length > 1)
                                IconPath = iconQuery[iconQuery.length - 1];
                        }

                        IconPixbuf = Utilities.GetIconFrom(IconPath, 64);

                    } else
                        IconPixbuf = new Gdk.Pixbuf.from_file_at_scale(IconPath, 64, 64, true);


                    _DesktopItem = new Icon(Name, IconPixbuf, "", DFile.get_path(), false);
                }


                append(_DesktopItem);
                _DesktopItem.show_all();

            }

        }

        /* Determine screen size */
        public void DetermineSize () {

            var _Screen = Gdk.Screen.get_default();
            var Height = _Screen.height();

            if(Height <= 480)
               EdgeLimit = 3;
            else if(Height <= 600 && Height > 480)
                EdgeLimit = 4;
            else if(Height <= 768 && Height > 600)
                EdgeLimit = 5;
            else if(Height <= 864 && Height > 768)
                EdgeLimit = 5;
            else if(Height <= 960 && Height > 864)
                EdgeLimit = 5;
            else if(Height > 960)
                EdgeLimit = 5;

        }


        /* Copies a file from a passed path to Desktop */
        public void copyToDesktop (string path) {

            var file = File.new_for_path(path);

            // Check if the file exists
            if(file.query_exists()) {

                var destinationFile = File.new_for_path(DesktopPath + "/" + file.get_basename());

                // Copy the file to desktop
                try {

                    file.copy (destinationFile, 0, null, (current_num_bytes, total_num_bytes) => {  });

                } catch (Error e) {
                    print (@"Error copying file: $(e.message)\n");
                }
            }

        }

        /* Finds the icon of a file and returns as string */
        string LoadIcon (File file) {

            /* Check if it's a .desktop */
            if(file.get_basename().has_suffix(".desktop")) {

                try {

                    var _KeyFile = new KeyFile();

                    _KeyFile.load_from_file(file.get_path(), 0);

                    return _KeyFile.get_string(KeyFileDesktop.GROUP,
                                               KeyFileDesktop.KEY_ICON);

                } catch {


                }

            }
                
            var Standard = FileAttribute.STANDARD_ICON;
            var Thumb = FileAttribute.THUMBNAIL_PATH;
            var CustomName = "metadata::custom-icon-name";
            var CustomIcon = "standard::icon";

            var Query = "%s,%s,%s,%s".printf(Thumb, Standard, CustomIcon, CustomName);

            var Info = file.query_info (Query, 0);
 
            // look for a thumbnail
            var thumb_icon = Info.get_attribute_byte_string (Thumb);
            if (thumb_icon != null && thumb_icon != "")
                return thumb_icon;
                
            // otherwise try to get the icon from the fileinfo
            return null;

        }

    }
}
