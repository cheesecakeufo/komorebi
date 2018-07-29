//
//  Copyright (C) 2015-2018 Abraham Masri @cheesecakeufo
//
//  This program is free software: you can redistribute it and/or modify it
//  under the terms of the GNU Lesser General Public License version 3, as published
//  by the Free Software Foundation.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranties of
//  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
//  PURPOSE.  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program.  If not, see <http://www.gnu.org/licenses/>

using Clutter;

using Komorebi.Utilities;

namespace Komorebi.OnScreen {

    public class AssetActor : Actor {

        BackgroundWindow parent;

        // Image(Asset) and its pixbuf
        Image image = new Image();
        Gdk.Pixbuf pixbuf;

        public uint assetAnimationTimeout;

        // Animation-specific variables
        string cloudsDirection = "right";
        string fadeType = "in";

        public AssetActor (BackgroundWindow parent) {
            this.parent = parent;
            set_content(image);
        }

        public void setAsset() {

            if(!assetVisible) {
                pixbuf = null;
                image.set_data (pixbuf.get_pixels(), pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                            pixbuf.get_width(), pixbuf.get_height(),
                            pixbuf.get_rowstride());
                fadeOut();
                return;
            }

            if(assetWidth <= 0)
                assetWidth = screenWidth;
            if(assetHeight <= 0)
                assetHeight = screenHeight;

            var assetPath = @"/System/Resources/Komorebi/$wallpaperName/assets.png";

            // make sure the asset exists
            if(!File.new_for_path(assetPath).query_exists()) {
                print(@"[WARNING]: asset with path: $assetPath does not exist\n");
                return;
            }

            if(assetWidth != 0 && assetHeight != 0)
                pixbuf = new Gdk.Pixbuf.from_file_at_scale(assetPath, assetWidth, assetHeight, false);
            else
                pixbuf = new Gdk.Pixbuf.from_file(assetPath);

            image.set_data (pixbuf.get_pixels(), pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                            pixbuf.get_width(), pixbuf.get_height(),
                            pixbuf.get_rowstride());


            x = 0;
            y = 0;
            opacity = 255;
            remove_all_transitions();

            setMargins();

            if(shouldAnimate())
                animate();
            else
                fadeIn();
        }

        void setMargins() {

            translation_y = 0;
            translation_x = 0;

            translation_y += assetMarginTop;
            translation_x -= assetMarginRight;
            translation_x += assetMarginLeft;
            translation_y -= assetMarginBottom;
        }

        void animate () {

            if(assetAnimationSpeed <= 10) {
                assetAnimationSpeed = 100;
                print("[WARNING]: The Asset Animation Speed has been adjusted in this wallpaper. Please consider updating it to at least 100\n");
            }


            assetAnimationTimeout = Timeout.add(assetAnimationSpeed * 30, () => {

                switch (assetAnimationMode) {

                    case "clouds":
                        if(cloudsDirection == "right") {

                            if(x + (width / 2) >= screenWidth)
                                cloudsDirection = "left";
                            else {
                                save_easing_state ();
                                set_easing_duration (assetAnimationSpeed * 100);
                                x += 60;
                                set_easing_mode (Clutter.AnimationMode.LINEAR);
                                restore_easing_state ();
                            }

                        } else {

                            if(x <= 0)
                                cloudsDirection = "right";
                            else {
                                save_easing_state ();
                                set_easing_duration (assetAnimationSpeed * 100);
                                x -= 60;
                                set_easing_mode (Clutter.AnimationMode.LINEAR);
                                restore_easing_state ();
                            }
                        }

                    break;

                    case "light":

                        if(fadeType == "in") {
                            fadeIn(assetAnimationSpeed * 100);
                            fadeType = "out";
                        } else {
                            fadeOut(assetAnimationSpeed * 100);
                            fadeType = "in";
                        }


                    break;
                }

                return true;
            });
        }

        public void fadeIn (int custom_duration = 90) {

            save_easing_state ();
            set_easing_duration (custom_duration);
            opacity = 255;
            set_easing_mode (Clutter.AnimationMode.LINEAR);
            restore_easing_state ();
        }

        public void fadeOut (int custom_duration = 90) {

            save_easing_state ();
            set_easing_duration (custom_duration);
            opacity = 0;
            set_easing_mode (Clutter.AnimationMode.LINEAR);
            restore_easing_state ();
        }

        public bool shouldAnimate () {

            if(wallpaperType == "video" ||
                wallpaperType == "web_page" ||
                assetAnimationMode == "noanimation") {
                
                if(assetAnimationTimeout > 0) {
                
                    Source.remove(assetAnimationTimeout);
                    assetAnimationTimeout = 0;
                }

                remove_all_transitions();
                fadeOut();

                return false;
            }

            return true;
        }

    }
}
