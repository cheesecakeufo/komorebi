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
using Gdk;


namespace Komorebi.OnScreen {

    public class BackgroundWindow : Gtk.Window {

        // Main container (image) (overlay(time)(assets))
        Gtk.Overlay lowerOverlay = new Overlay();

        // Background Image
        Image backgroundImage = new Image();
        Pixbuf backgroundPixbuf = null;

        // Fixed(Date/Time) and assets overlay
        Gtk.Overlay higherOverlay = new Overlay();

        // Contains Date and time box 
        Gtk.Box higherBox = new Box(Orientation.VERTICAL, 5);
        Gtk.Fixed dateTimeFixed = new Fixed();

        // Date and time box itself
        DateTimeBox dateTimeBox = new DateTimeBox();

        // Asset Image
        Image assetImage = new Image();
        Pixbuf assetPixbuf = null;


        // Screen Size
        int screenHeight = Gdk.Screen.get_default ().height();
        int screenWidth =  Gdk.Screen.get_default ().width();

        // Current animation mode
        string currentAnimationMode = "none";

        // Light asset time updater
        public uint lightTimeout;


        public BackgroundWindow () {

            title = "Background";
            set_size_request(screenWidth, screenHeight);
            resizable = false;
            set_type_hint(WindowTypeHint.DESKTOP);
            set_keep_below(true);
            app_paintable = false;
            skip_pager_hint = true;
            skip_taskbar_hint = true;
            accept_focus = true;
            stick ();
            decorated = false;
            add_events (EventMask.ENTER_NOTIFY_MASK   |
                        EventMask.POINTER_MOTION_MASK |
                        EventMask.SMOOTH_SCROLL_MASK);
            // Setup Widgets

            // Properties
            higherBox.hexpand = true;
            higherBox.vexpand = true;

            dateTimeBox.halign = Align.START;
            dateTimeBox.valign = Align.CENTER;
            dateTimeFixed.hexpand = false;


            initializeBackground("day_night_mountain");



            add(lowerOverlay);
        }

        void initializeBackground (string backgroundName) {

            // Read the config file
            var keyFile = new KeyFile();

            keyFile.load_from_file(@"/System/Resources/Komorebi/$backgroundName/config", KeyFileFlags.NONE);

            currentAnimationMode = keyFile.get_string ("Komorebi", "AnimationMode");
            int animationSpeed = keyFile.get_integer ("Komorebi", "AnimationSpeed");
            bool parallax = keyFile.get_boolean ("Komorebi", "Parallax");


            int dateTimeBoxMarginLeft = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginLeft");
            int dateTimeBoxMarginTop = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginTop");
            int dateTimeBoxMarginBottom = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginBottom");
            int dateTimeBoxMarginRight = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginRight");

            string dateTimeBoxHAlign = keyFile.get_string ("Komorebi", "DateTimeBoxHAlign");
            string dateTimeBoxVAlign = keyFile.get_string ("Komorebi", "DateTimeBoxVAlign");

            bool dateTimeBoxOnTop = keyFile.get_boolean ("Komorebi", "DateTimeBoxOnTop");

            string timeLabelAlignment = keyFile.get_string ("Komorebi", "TimeLabelAlignment");
            
            string dateTimeColor = keyFile.get_string ("Komorebi", "DateTimeColor");
            string dateTimeShadow = keyFile.get_string ("Komorebi", "DateTimeShadow");

            string timeLabelFont = keyFile.get_string ("Komorebi", "TimeLabelFont");
            string dateLabelFont = keyFile.get_string ("Komorebi", "DateLabelFont");

            // DateTime labels shadow
            Acis.ApplyCSS({dateTimeBox.timeLabel, dateTimeBox.dateLabel}, @"*{text-shadow: $dateTimeShadow;}");


            // DateTime box margins
            dateTimeFixed.margin_left = dateTimeBoxMarginLeft;
            dateTimeFixed.margin_top = dateTimeBoxMarginTop;
            dateTimeFixed.margin_bottom = dateTimeBoxMarginBottom;
            dateTimeFixed.margin_right = dateTimeBoxMarginRight;

            // DateTime box alignments
            if(dateTimeBoxHAlign == "start")
                dateTimeFixed.halign = Align.START;
            else if(dateTimeBoxHAlign == "center")
                dateTimeFixed.halign = Align.CENTER;
            else
                dateTimeFixed.halign = Align.END;


            if(dateTimeBoxVAlign == "start")
                dateTimeFixed.valign = Align.START;
            else if(dateTimeBoxVAlign == "center")
                dateTimeFixed.valign = Align.CENTER;
            else
                dateTimeFixed.valign = Align.END;


            // Time label alignment
            if(timeLabelAlignment == "start")
                dateTimeBox.timeLabel.halign = Align.START;
            else if(timeLabelAlignment == "center")
                dateTimeBox.timeLabel.halign = Align.CENTER;
            else
                dateTimeBox.timeLabel.halign = Align.END;

            // Cancel any previous timeout
            if(dateTimeBox.timeout > 0)
                Source.remove(dateTimeBox.timeout);

            if(lightTimeout > 0)
                Source.remove(lightTimeout);

            addWidgets(dateTimeBoxOnTop);
            loadBackground(backgroundName);
            dateTimeBox.loadDateTime(dateTimeColor, timeLabelFont, dateLabelFont);
            loadAssets(backgroundName, currentAnimationMode, animationSpeed);

            // Animation if parallax is enabled
            if(parallax) {


                motion_notify_event.connect((event) => {

                    // Calculate the percentage of how far the cursor is
                    // from the edges of the screen
                    var x = (int)((event.x / screenWidth) * 100) / 15;
                    var y = (int)((event.y / screenHeight) * 100) / 15;


                    dateTimeFixed.move(dateTimeBox, -x, -y);


                    return true;
                });



            }


        }

        void addWidgets(bool dateTimeBoxOnTop) {

            dateTimeFixed.put(dateTimeBox, 0, 0);

            // Determine whether we should place the date and time on the top or not
            if(dateTimeBoxOnTop) {
                higherOverlay.add(assetImage);
                higherOverlay.add_overlay(dateTimeFixed);

            } else {
                higherOverlay.add(dateTimeFixed);
                higherOverlay.add_overlay(assetImage);

            }

            lowerOverlay.add(backgroundImage);
            lowerOverlay.add_overlay(higherOverlay);



        }

        void loadBackground(string backgroundName) {

            backgroundPixbuf = new Gdk.Pixbuf.from_file_at_scale(@"/System/Resources/Komorebi/$backgroundName/bg.jpg", screenWidth, screenHeight, false);
            backgroundImage.set_from_pixbuf(backgroundPixbuf);


        }


        void loadAssets(string backgroundName, string animationMode, int animationSpeed) {

            // assets aren't allowed in 'gradient'
            // mode. Use CSS gradient instead
            if(animationMode == "gradient") {
                assetPixbuf = new Gdk.Pixbuf.from_file_at_scale(@"/System/Resources/Komorebi/$backgroundName/assets.png", screenWidth, screenHeight, false);
                assetImage.set_from_pixbuf(assetPixbuf);
            }

            // Load animation
            switch (animationMode) {

                case "clouds":
                    Acis.ApplyCSS({assetImage}, @"*{
                        animation: displace $(animationSpeed.to_string())s linear infinite;
                        }

                        @keyframes displace {
                            0% { padding-left: 0 }
                            25% { padding-left: 664px }
                            50% { padding-left: 0px }
                            75% { padding-left: 664px }
                            100% { padding-left: 0; }
                        }");
                    break;

                case "light":

                    assetImage.set_opacity(0.0);

                    var revealing = true;

                    lightTimeout = Timeout.add(animationSpeed, () => {

                        var currentOpacity = assetImage.get_opacity();

                        if(revealing) {

                            if(currentOpacity > 0.9) {
                                revealing = false;
                                return true;
                            } else {
                                currentOpacity += 0.01;
                            }

                        } else {

                            if(currentOpacity < 0.1) {
                                revealing = true;
                                return true;
                            } else {
                                currentOpacity -= 0.01;
                            }

                        }
                        

                        assetImage.set_opacity(currentOpacity);

                        return true;

                    });

                    break;

                case "gradient":
                    break;

                case "noanimation":
                    break;


            }



        }

        /* Shows the window */
        public void fadeIn() {

            show_all();
            this.set_opacity(0.0);

            Timeout.add(20, () => {

                var currentOpacity = this.get_opacity();

                if(currentOpacity > 1.0)
                    return false;
                else
                    currentOpacity += 0.1;
                        
                this.set_opacity(currentOpacity);

                return true;

            });

        }



    }
}
