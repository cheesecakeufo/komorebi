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

namespace WallpaperCreator.OnScreen {

    public class InitialPage : Box {

        Grid aboutGrid = new Grid();

        Box titleBox = new Box(Orientation.VERTICAL, 5);
        Label titleLabel = new Label("");
        Label aboutLabel = new Label("");


        Label nameLabel = new Label("Give your wallpaper a name:");
        Entry nameEntry = new Entry() { placeholder_text = "Mountain Summit" };

        FileFilter imageFilter = new FileFilter ();
        FileFilter videoFilter = new FileFilter ();

        Label typeLabel = new Label("My wallpaper is");
        ComboBoxText typeComboBox = new ComboBoxText();

        Label chooseFileLabel = new Label("Where is the image located?");
        Box locationBox = new Box(Orientation.HORIZONTAL, 10);
        Entry locationEntry = new Entry() { placeholder_text = "/Users/cheesecakeufo/my_picture.jpg" };
        FileChooserButton chooseFileButton = new FileChooserButton("Choose File", Gtk.FileChooserAction.OPEN);

        Revealer revealer = new Revealer();

        Box thumbnailBox = new Box(Orientation.VERTICAL, 5);
        Label chooseThumbnailLabel = new Label("Where is the thumbnail located?");
        FileChooserButton chooseThumbnailButton = new FileChooserButton("Choose Thumbnail", Gtk.FileChooserAction.OPEN);

        public InitialPage() {

            spacing = 10;
            hexpand = true;
            vexpand = true;
            orientation = Orientation.VERTICAL;
            halign = Align.CENTER;
            valign = Align.CENTER;

            aboutGrid.halign = Align.CENTER;
            aboutGrid.margin_bottom = 30;
            aboutGrid.column_spacing = 0;
            aboutGrid.row_spacing = 0;

            titleBox.margin_top = 15;
            titleBox.margin_start = 10;
            titleLabel.halign = Align.START;

            titleLabel.set_markup("<span font='Lato Light 30px' color='white'>Komorebi Wallpaper Creator</span>");
            aboutLabel.set_markup("<span font='Lato Light 15px' color='white'>by Abraham Masri @cheesecakeufo</span>");

            aboutLabel.halign = Align.START;

            typeComboBox.append("image", "An image");
            typeComboBox.append("video", "A video");
            typeComboBox.append("web_page", "A web page");
            typeComboBox.active = 0;

            wallpaperType = "image";

            imageFilter.add_mime_type ("image/*");
            videoFilter.add_mime_type ("video/*");

            chooseFileButton.set_filter (imageFilter);
            chooseFileButton.width_chars = 10;

            chooseThumbnailButton.set_filter (imageFilter);
            chooseThumbnailButton.width_chars = 10;
            
            locationEntry.set_sensitive(false);

            // Signals
            nameEntry.changed.connect(() => {

                if(nameEntry.text.length <= 0)
                    wallpaperName = null;
                else
                    wallpaperName = nameEntry.text;
            });

            typeComboBox.changed.connect(() => {
                wallpaperType = typeComboBox.get_active_id();

                if(wallpaperType == "image") {

                    chooseFileButton.set_filter (imageFilter);
                    chooseFileLabel.label = "Where is the image located?";
                    locationEntry.placeholder_text = "/Users/cheesecakeufo/my_picture.jpg";
                    locationEntry.set_sensitive(false);
                 
                    revealer.set_reveal_child(false);
                
                    chooseFileButton.show();

                } else if(wallpaperType == "web_page") {

                    chooseFileButton.set_filter (imageFilter);
                    chooseFileLabel.label = "What is the URL?";
                    locationEntry.placeholder_text = "https://sample.com/random/{{screen_width}}x{{screen_height}}";
                    locationEntry.set_sensitive(true);

                    revealer.set_reveal_child(true);
                
                    chooseFileButton.hide();

                } else {

                    chooseFileButton.set_filter (videoFilter);
                    chooseFileLabel.label = "Where is the video located?";
                    locationEntry.placeholder_text = "/Users/cheesecakeufo/my_video.mp4";
                    locationEntry.set_sensitive(false);
                    
                    revealer.set_reveal_child(true);
                 
                    chooseFileButton.show();
                }

            });

            chooseFileButton.file_set.connect (() => {

                filePath = chooseFileButton.get_file().get_path();

            });


            chooseThumbnailButton.file_set.connect (() => {

                thumbnailPath = chooseThumbnailButton.get_file().get_path();
            });

            locationEntry.changed.connect(() => {

                if(locationEntry.text.length <= 0 || !locationEntry.text.contains("http"))
                    webPageUrl = null;
                else
                    webPageUrl = locationEntry.text;
            });

            titleBox.add(titleLabel);
            titleBox.add(aboutLabel);

            aboutGrid.attach(new Image.from_file("/System/Resources/Komorebi/wallpaper_creator.svg"), 0, 0, 1, 1);
            aboutGrid.attach(titleBox, 1, 0, 1, 1);

            thumbnailBox.add(chooseThumbnailLabel);
            thumbnailBox.add(chooseThumbnailButton);

            revealer.add(thumbnailBox);

            locationBox.pack_start(locationEntry);
            locationBox.add(chooseFileButton);

            add(aboutGrid);
            add(nameLabel);
            add(nameEntry);

            add(typeLabel);
            add(typeComboBox);

            add(chooseFileLabel);
            add(locationBox);
            
            add(revealer);
        }
    }
}
