//
//  Copyright (C) 2015-2017 Abraham Masri <imasrim114@gmail.com>
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

        // Image(Asset) and its pixbuf
        Image image = new Image();
        Gdk.Pixbuf pixbuf;

        public uint assetAnimationTimeout;

        // Animation-specific variables
        string cloudsDirection = "right";
        string fadeType = "in";

        public AssetActor () {

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

            if(assetWidth != 0 && assetHeight != 0)
                pixbuf = new Gdk.Pixbuf.from_file_at_scale(@"/System/Resources/Komorebi/$wallpaperName/assets.png",
                                                            assetWidth, assetHeight, false);
            else
                pixbuf = new Gdk.Pixbuf.from_file(@"/System/Resources/Komorebi/$wallpaperName/assets.png");

            image.set_data (pixbuf.get_pixels(), pixbuf.has_alpha ? Cogl.PixelFormat.RGBA_8888 : Cogl.PixelFormat.RGB_888,
                            pixbuf.get_width(), pixbuf.get_height(),
                            pixbuf.get_rowstride());


            x = 0;
            y = 0;
            opacity = 255;
            remove_all_transitions();

            // setPosition();
            setMargins();

            if(shouldAnimate())
                animate();
            else
                fadeIn();
        }

        void setPosition() {

            switch (assetPosition) {

                case "top_right":
                    x = 0;
                    y = 0;
                break;

                case "top_center":
                    x = (mainActor.width / 2) - (width / 2);
                    y = 0;
                break;

                case "top_left":
                    x = (mainActor.width / 2) - width;
                    y = 0;
                break;

                case "center_right":
                    x = 0;
                    y = (mainActor.height / 2) - (height / 2);
                break;

                case "center":
                    x = (mainActor.width / 2) - (width / 2);
                    y = (mainActor.height / 2) - (height / 2);
                break;

                case "center_left":
                    x = (mainActor.width / 2) - width;
                    y = (mainActor.height / 2) - (height / 2);
                break;

                case "bottom_right":
                    x = 0;
                    y = (mainActor.height / 2) - height;
                break;

                case "bottom_center":
                    x = (mainActor.width / 2) - (width / 2);
                    y = (mainActor.height / 2) - height;
                break;

                case "bottom_left":
                    x = (mainActor.width / 2) - width;
                    y = (mainActor.height / 2) - height;
                break;

                default:
                break;
            }
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

            if(wallpaperType == "video" || assetAnimationMode == "noanimation") {
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
