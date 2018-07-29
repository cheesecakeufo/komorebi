//
//  Copyright (C) 2015-2016 Abraham Masri @cheesecakeufo
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

using Gdk;
using Clutter;

namespace Komorebi.OnScreen {

    public class BubbleMenuItem : Actor {

        public Text text = new Text();

        public BubbleMenuItem (string title) {

            // Properties
            set_reactive (true);
            x_align = ActorAlign.START;
            x_expand = true;
            margin_top = 5;

            text.font_name = "Lato 15";
            text.text = title;
            text.set_color(Clutter.Color.from_string("white"));

            // Signals
            signalsSetup();

            add_child(text);

        }

        void signalsSetup () {


            button_press_event.connect((e) => {

                opacity = 100;

                return false;
            });

            motion_event.connect((e) => {

                opacity = 200;

                return false;
            });

            leave_event.connect((e) => {

                opacity = 255;

                return false;
            });
        }
    }
}
