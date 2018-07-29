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
using Clutter;

using Komorebi.Utilities;

using GLib.Environment;

namespace Komorebi.OnScreen {

    // File/Directory info Window
    InfoWindow infoWindow;

    public class DesktopIcons : ResponsiveGrid {

        BackgroundWindow parent;
        public BackgroundWindow window { get { return parent; } }

        /* Desktops path */
        string DesktopPath = Environment.get_user_special_dir(UserDirectory.DESKTOP);

        FileMonitor fileMonitor;

        // List of icons (used to make things faster when reloading)
        public Gee.ArrayList<Icon> iconsList { get; private set; }

        public DesktopIcons (BackgroundWindow parent) {
            this.parent = parent;

            infoWindow = new InfoWindow();
            iconsList = new Gee.ArrayList<Icon>();

            margin_top = 60;
            margin_left = 120;
            y_expand = true;
            iconSize = 64;

            monitorChanges();
            getDesktops();
        }

        /* Watch for Changes */
        void monitorChanges () {

            fileMonitor = File.new_for_path(DesktopPath).monitor(0);

            fileMonitor.changed.connect((e,a,event) => {
                if(event == FileMonitorEvent.DELETED || event == FileMonitorEvent.CREATED) {
                    getDesktops();
                    addIconsFromQueue();
                }


            });
        }

        /* Get .desktop(s) */
        public void getDesktops () {

            iconsList.clear();
            grabDesktopPaths();
            addTrashIcon();
        }

        /* Adds all icons from the queue */
        public void addIconsFromQueue () {

            itemsLimit = (int)Math.round(screenHeight / (83 + verticalLayout.spacing));

            clearIcons();
            destroy_all_children();

            foreach (var icon in iconsList) {
                append(icon);
                icon.unDimIcon();
            }
        }

        /* Async get desktop items */
        public void grabDesktopPaths () {

            var desktopFile = File.new_for_path (DesktopPath);

            // Reads all files in the directory
            var Enum = desktopFile.enumerate_children ("standard::*", FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
            FileInfo info;

            while ((info = Enum.next_file ()) != null) {

                // Location of the file
                string FilePath = DesktopPath + "/" + info.get_name ();

                string name = info.get_name();
                Gdk.Pixbuf iconPixbuf = null;
                var Path = FilePath;
                var DFile = File.new_for_path(FilePath);
                OnScreen.Icon icon = null;

                /* Check if the file is .desktop */
                if(DFile.get_basename().has_suffix(".desktop")) {

                    var keyFile = new KeyFile();
                    keyFile.load_from_file(DFile.get_path(), 0);

                    // make sure the keyFile has the required keys
                    if(!keyFile.has_key(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_NAME) ||
                        !keyFile.has_key(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_ICON) ||
                        !keyFile.has_key(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_EXEC))
                        continue;

                    name = keyFile.get_string(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_NAME);

                    var iconPath = keyFile.get_string(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_ICON);

                    iconPixbuf = Utilities.getIconFrom(iconPath, iconSize);

                    Path = keyFile.get_string(KeyFileDesktop.GROUP, KeyFileDesktop.KEY_EXEC);

                    icon = new Icon(this, name, iconPixbuf, Path, DFile.get_path(), true);



                } else {

                    string iconPath = LoadIcon(DFile);

                    if(iconPath == null) {
                        if(DFile.query_file_type(FileQueryInfoFlags.NONE) == FileType.DIRECTORY)
                            iconPath = "folder";
                        else {

                            var iconQuery = DFile.query_info("standard::icon", 0).get_icon ().to_string().split(" ");
                            if(iconQuery.length > 1)
                                iconPath = iconQuery[iconQuery.length - 1];
                        }

                        iconPixbuf = Utilities.getIconFrom(iconPath, iconSize);

                    } else
                        iconPixbuf = new Gdk.Pixbuf.from_file_at_scale(iconPath, iconSize, iconSize, false);


                    icon = new Icon(this, name, iconPixbuf, "", DFile.get_path(), false);
                }


                iconsList.add(icon);

            }
        }

        /* Adds trash icon */
        private void addTrashIcon() {

            iconsList.add(new Icon.Trash(this));
        }


        /* Creates a new folder */
        public void createNewFolder () {

            var untitledFolder = File.new_for_path(getUntitledFolderName());
            untitledFolder.make_directory_async();

        }

        /* Pastes a file from a given path to desktop */
        public void copyToDesktop (string path) {

            // Get the actual GLib file
            var file = File.new_for_path(path);
            var desktopFile = File.new_for_path(desktopPath + "/" + file.get_basename());
            file.copy(desktopFile, FileCopyFlags.NONE, null);

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

        public void fadeIn () {

            save_easing_state ();
            set_easing_duration (200);
            opacity = 255;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

        }

        public void fadeOut () {

            save_easing_state ();
            set_easing_duration (200);
            opacity = 0;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

        }

        /* Returns a new Untitled Folder name */
        private string getUntitledFolderName(int count = 0) {

            string path = desktopPath + @"/New Folder($(count.to_string()))";
            if(File.new_for_path(path).query_exists())
                path = getUntitledFolderName(count + 1);

            return path;
        }

    }
}
