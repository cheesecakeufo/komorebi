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

    public class FinalPage : Box {

        Image logo = new Image.from_file("/System/Resources/Komorebi/done.svg");

        Label titleLabel = new Label("");
        Label descLabel = new Label("");

        Button closeButton = new Button.with_label("Close");

        public FinalPage() {

            spacing = 10;
            hexpand = true;
            vexpand = true;
            orientation = Orientation.VERTICAL;
            halign = Align.CENTER;
            valign = Align.CENTER;

            logo.margin_bottom = 30;

            descLabel.justify = Justification.CENTER;
            descLabel.halign = Align.CENTER;
            descLabel.hexpand = false;
            descLabel.selectable = true;

            titleLabel.set_markup("<span font='Lato 20'>Done</span>");

            var mv_command = @"sudo mv $(Environment.get_home_dir())/$(wallpaperName.replace(" ", "_").replace(".", "_").down()) /System/Resources/Komorebi";

            descLabel.set_markup(@"<span font='Lato Light 12'>Open 'Terminal' then paste the following:\n<b>$mv_command</b>\nOnce done, you can change the wallpaper in <i>'Change Wallpaper'</i>.</span>");

            closeButton.margin_top = 20;
            closeButton.halign = Align.CENTER;

            // Signals
            closeButton.released.connect(() => {

                print("My job is done. Good bye!\n");
                Gtk.main_quit();
            });


            add(logo);
            add(titleLabel);
            add(descLabel);
            add(closeButton);

            createWallpaper();
        }

        /* Creates a wallpaper */
        private void createWallpaper() {

            // Create a new directory
            wallpaperName = wallpaperName.replace(" ", "_").replace(".", "_").down();

            var dirPath = @"$(Environment.get_home_dir())/$(wallpaperName)";
            File.new_for_path(dirPath).make_directory_with_parents();
            var configPath = dirPath + "/config";
            var configFile = File.new_for_path(configPath);

            var configKeyFile = new KeyFile();

            configKeyFile.set_string("Info", "WallpaperType", wallpaperType);

            if(wallpaperType == "video") {

                var videoFileNameArray = filePath.split("/");
                var videoFileName = videoFileNameArray[videoFileNameArray.length - 1];
                configKeyFile.set_string("Info", "VideoFileName", videoFileName);

                // Copy the video into our new dir
                File.new_for_path(filePath).copy(File.new_for_path(dirPath + @"/$videoFileName"), FileCopyFlags.NONE);
                

            } else if (wallpaperType == "web_page")
                configKeyFile.set_string("Info", "WebPageUrl", webPageUrl);


            if(wallpaperType == "video" || wallpaperType == "web_page") {

                // Move the thumbnail
                File.new_for_path(thumbnailPath).copy(File.new_for_path(dirPath + "/wallpaper.jpg"), FileCopyFlags.NONE);
            
            } else {

                // Copy the wallpaper into our new dir
                File.new_for_path(filePath).copy(File.new_for_path(dirPath + "/wallpaper.jpg"), FileCopyFlags.NONE);
            }

            configKeyFile.set_boolean("DateTime", "Visible", showDateTime);
            configKeyFile.set_boolean("DateTime", "Parallax", dateTimeParallax);

            configKeyFile.set_integer("DateTime", "MarginTop", marginTop);
            configKeyFile.set_integer("DateTime", "MarginRight", marginRight);
            configKeyFile.set_integer("DateTime", "MarginLeft", marginLeft);
            configKeyFile.set_integer("DateTime", "MarginBottom", marginBottom);

            // TODO: Add support for rotations
            configKeyFile.set_integer("DateTime", "RotationX", 0);
            configKeyFile.set_integer("DateTime", "RotationY", 0);
            configKeyFile.set_integer("DateTime", "RotationZ", 0);

            configKeyFile.set_string("DateTime", "Position", position);
            configKeyFile.set_string("DateTime", "Alignment", alignment);
            configKeyFile.set_boolean("DateTime", "AlwaysOnTop", dateTimeAlwaysOnTop);

            configKeyFile.set_string("DateTime", "Color", dateTimeColor);
            configKeyFile.set_integer("DateTime", "Alpha", dateTimeAlpha);

            configKeyFile.set_string("DateTime", "ShadowColor", shadowColor);
            configKeyFile.set_integer("DateTime", "ShadowAlpha", shadowAlpha);

            configKeyFile.set_string("DateTime", "TimeFont", timeFont);
            configKeyFile.set_string("DateTime", "DateFont", dateFont);


            if(wallpaperType == "image") {

                configKeyFile.set_boolean("Wallpaper", "Parallax", wallpaperParallax);

                if(assetPath == null || assetPath == "")
                    showAsset = false;

                configKeyFile.set_boolean("Asset", "Visible", showAsset);
                configKeyFile.set_string("Asset", "AnimationMode", animationMode);
                configKeyFile.set_integer("Asset", "AnimationSpeed", animationSpeed);

                configKeyFile.set_integer("Asset", "Width", 0);
                configKeyFile.set_integer("Asset", "Height", 0);

                if(assetPath != null) {
                    // Move the asset into our new dir
                    File.new_for_path(assetPath).copy(File.new_for_path(dirPath + "/assets.png"), FileCopyFlags.NONE);
                }
            }

            // save the key file
            var stream = new DataOutputStream (configFile.create (0));
            stream.put_string (configKeyFile.to_data ());
            stream.close ();

        }
    }
}
