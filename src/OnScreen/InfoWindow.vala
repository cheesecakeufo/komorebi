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
using Komorebi.Utilities;

using GLib.Environment;

namespace Komorebi.OnScreen {


    public class InfoWindow : Gtk.Window {

    	// Box containing everything
    	private Box mainBox = new Box(Orientation.VERTICAL, 0);

        // Box contains close button (acts like HeaderBar)
        private Box headerBar = new Box(Orientation.HORIZONTAL, 5);

    	// Box contains title label, and size
    	private Box topBox = new Box(Orientation.VERTICAL, 5);

    	// Close/Hide button
    	private Button closeButton = new Button();

    	// File/Directory title
    	public Label titleLabel = new Label("No name");

    	// File/Directory size
    	public Label sizeLabel = new Label("Size unknown");

        // Separator
        private Separator separator = new Separator(Orientation.HORIZONTAL);


        // Box more file info and properties
        private Box fileInfoBox = new Box(Orientation.VERTICAL, 5);

        // Location
        public RowLabel locationLabel = new RowLabel("Location");

        // Type
        public RowLabel typeLabel = new RowLabel("Type");

        // Accessed
        public RowLabel accessedLabel = new RowLabel("Accessed");

        // Modified
        public RowLabel modifiedLabel = new RowLabel("Modified");

        // Owner
        public RowLabel ownerLabel = new RowLabel("Owner");

        string headerBarCSS = "*{
                                background-color: rgba(25,25,25,0.7);
                                border-width: 0px;
                                box-shadow: none;
                                border-top-left-radius: 0.6em;
                                border-top-right-radius: 0.6em;
                                border-color: @transparent;
                                }";

        string windowCSS = "*{

                                background-color: rgba(25,25,25,0.7);
                                border-width: 0px;
                                box-shadow: none;
                                border-bottom-left-radius: 0.6em;
                                border-bottom-right-radius: 0.6em;
                                color: white;
                                }";

        string separatorCSS = "*{
                                color: rgba(51,51,51,0.6);
                                }";
    	public InfoWindow() {

            // Configure the window
            set_size_request(340, 390);
            resizable = false;
            set_titlebar(headerBar);
            addAlpha({this});
            applyCSS({this}, windowCSS);

            // Configure widgets
            applyCSS({headerBar}, headerBarCSS);
            closeButton.set_halign(Align.START);

            titleLabel.set_halign(Align.CENTER);
            titleLabel.set_line_wrap(true);
            titleLabel.set_max_width_chars(19);
            titleLabel.set_ellipsize(Pango.EllipsizeMode.MIDDLE);
            titleLabel.set_selectable(true);

            separator.margin_top = 10;
            separator.margin_bottom = 10;
            applyCSS({separator}, separatorCSS);

            fileInfoBox.margin = 20;

            // Signals
            closeButton.button_press_event.connect(() => {
                this.hide();
                return true;
            });

    		// Add widgets
            closeButton.add(new Image.from_file("/System/Resources/Komorebi/close_btn.svg"));
    		headerBar.pack_start(closeButton, false, false);

    		topBox.add(titleLabel);
    		topBox.add(sizeLabel);


            fileInfoBox.add(locationLabel);
            fileInfoBox.add(typeLabel);
            fileInfoBox.add(accessedLabel);
            fileInfoBox.add(modifiedLabel);
            fileInfoBox.add(ownerLabel);

            mainBox.add(topBox);
            mainBox.add(separator);
    		mainBox.add(fileInfoBox);
    		add(mainBox);

            closeButton.grab_focus();
    	}

        /* Set window information */
        public void setInfoFromPath(string path) {

            File file = File.new_for_path(path);
            FileInfo fileInfo = file.query_info("%s,%s,%s,%s,%s,%s".printf(
                                       FileAttribute.STANDARD_SIZE,
                                       FileAttribute.STANDARD_TYPE,
                                       FileAttribute.STANDARD_CONTENT_TYPE,
                                       FileAttribute.TIME_ACCESS,
                                       FileAttribute.TIME_CHANGED,
                                       FileAttribute.OWNER_USER
                                       )    , 0);

            var accessedTime = (int64) fileInfo.get_attribute_uint64(FileAttribute.TIME_ACCESS);
            var modifiedTime = (int64) fileInfo.get_attribute_uint64(FileAttribute.TIME_CHANGED);
            var owner = fileInfo.get_attribute_string(FileAttribute.OWNER_USER);

            titleLabel.set_markup(@"<span font='Lato 13'>$(file.get_basename())</span>");
            sizeLabel.set_markup(@"<span font='Lato 10'>$(GLib.format_size (fileInfo.get_size()))</span>");

            locationLabel.set_value(path);
            typeLabel.set_value(fileInfo.get_content_type());
            accessedLabel.set_value(formatDateTime((new DateTime.from_unix_utc(accessedTime)).to_local()));
            modifiedLabel.set_value(formatDateTime((new DateTime.from_unix_utc(modifiedTime)).to_local()));
            ownerLabel.set_value(owner);

        }
    }


}
