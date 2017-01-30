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

        // Date and time labels box
        Gtk.Box dateTimeBox = new Box(Orientation.VERTICAL, 5);
        Gtk.Label timeLabel = new Label("12:04am");
        Gtk.Label dateLabel = new Label("October, 8th 2017");

        // Asset Image
        Image assetImage = new Image();
        Pixbuf assetPixbuf = null;


        // Screen Size
        int screenHeight = Gdk.Screen.get_default ().height();
        int screenWidth =  Gdk.Screen.get_default ().width();


        public BackgroundWindow () {

            title = "Background";
            set_size_request(screenWidth, screenHeight);
            resizable = false;
            // set_type_hint(WindowTypeHint.DESKTOP);
            // set_keep_below(true);
            app_paintable = false;
            // skip_pager_hint = true;
            // skip_taskbar_hint = true;
            accept_focus = true;
            stick ();
            decorated = false;

            // Setup Widgets

            // Properties
            higherBox.hexpand = true;
            higherBox.vexpand = true;

            dateTimeBox.margin_top = 80;
            dateTimeBox.halign = Align.START;
            dateTimeBox.valign = Align.CENTER;

            initializeBackground();

            // Add Widgets
            dateTimeBox.add(timeLabel);
            dateTimeBox.add(dateLabel);

            higherBox.pack_start(dateTimeBox);

            higherOverlay.add(higherBox);
            higherOverlay.add_overlay(assetImage);

            lowerOverlay.add(backgroundImage);
            lowerOverlay.add_overlay(higherOverlay);

            add(lowerOverlay);
        }

        void initializeBackground () {

            // Read the config file
            var keyFile = new KeyFile();

            keyFile.load_from_file("/System/Resources/Komorebi/dark_forest/config", KeyFileFlags.NONE);

            string animationMode = keyFile.get_string ("Komorebi", "AnimationMode");


            int dateTimeBoxMarginLeft = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginLeft");
            int dateTimeBoxMarginTop = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginTop");
            int dateTimeBoxMarginBottom = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginBottom");
            int dateTimeBoxMarginRight = keyFile.get_integer ("Komorebi", "DateTimeBoxMarginRight");

            string dateTimeBoxHAlign = keyFile.get_string ("Komorebi", "DateTimeBoxHAlign");
            string dateTimeBoxVAlign = keyFile.get_string ("Komorebi", "DateTimeBoxVAlign");



            string timeLabelAlignment = keyFile.get_string ("Komorebi", "TimeLabelAlignment");
            string dateTimeColor = keyFile.get_string ("Komorebi", "DateTimeColor");


            string timeLabelSize = keyFile.get_string ("Komorebi", "TimeLabelSize");
            string dateLabelSize = keyFile.get_string ("Komorebi", "DateLabelSize");


            // DateTime box margins
            dateTimeBox.margin_left = dateTimeBoxMarginLeft;
            dateTimeBox.margin_top = dateTimeBoxMarginTop;
            dateTimeBox.margin_bottom = dateTimeBoxMarginBottom;
            dateTimeBox.margin_right = dateTimeBoxMarginRight;

            // DateTime box alignments
            if(dateTimeBoxHAlign == "start")
                dateTimeBox.halign = Align.START;
            else if(dateTimeBoxHAlign == "center")
                dateTimeBox.halign = Align.CENTER;
            else
                dateTimeBox.halign = Align.END;


            if(dateTimeBoxVAlign == "start")
                dateTimeBox.valign = Align.START;
            else if(dateTimeBoxVAlign == "center")
                dateTimeBox.valign = Align.CENTER;
            else
                dateTimeBox.valign = Align.END;


            // Time label alignment
            if(timeLabelAlignment == "start")
                timeLabel.halign = Align.START;
            else if(timeLabelAlignment == "center")
                timeLabel.halign = Align.CENTER;
            else
                timeLabel.halign = Align.END;


            loadBackground("dark_forest");
            loadDateTime(dateTimeColor, timeLabelSize, dateLabelSize);
            loadAssets("dark_forest", animationMode);


        }

        void loadBackground(string backgroundName) {

            backgroundPixbuf = new Gdk.Pixbuf.from_file_at_scale(@"/System/Resources/Komorebi/$backgroundName/bg.jpg", screenWidth, screenHeight, false);
            backgroundImage.set_from_pixbuf(backgroundPixbuf);


        }

        void loadDateTime(string color, string timeSize, string dateSize) {

            timeLabel.set_markup(@"<span color='$color' font='Lato Hairline $timeSize'>12:04am</span>");
            dateLabel.set_markup(@"<span color='$color' font='Lato Hairline $dateSize'>October 8, 2017</span>");




        }

        void loadAssets(string backgroundName, string animationMode) {

            assetPixbuf = new Gdk.Pixbuf.from_file_at_scale(@"/System/Resources/Komorebi/$backgroundName/assets.png", screenWidth, screenHeight, false);
            assetImage.set_from_pixbuf(assetPixbuf);


            // Load animation
            switch (animationMode) {

                case "clouds":
                    Acis.ApplyCSS({assetImage}, "*{
                        animation: displace 100s linear infinite;
                        }

                        @keyframes displace {
                            0% { padding-left: 0 }
                            25% { padding-left: 664px }
                            50% { padding-left: 0px }
                            75% { padding-left: 664px }
                            100% { padding-left: 0; }
                        }");
                    break;

                case "noanimation":
                    break;


            }



        }

        /* Shows the window */
        public void FadeIn() {

            show_all();

        }



    }
}
