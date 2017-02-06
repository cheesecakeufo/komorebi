//
//  Copyright (C) 2015-2016 Abraham Masri <imasrim114@gmail.com>
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

using Gtk;
using Cairo;

namespace Komorebi.OnScreen {

    public class DateTimeBox: Box {

        // Labels box
        Gtk.Box mainContainer = new Box(Orientation.VERTICAL, 5);

        // Date and time labels
        public Gtk.Label timeLabel = new Label("");
        public Gtk.Label dateLabel = new Label("");

        // Time updater
        public uint timeout;

        // Time format
        string timeFormat = "%l:%M %p";

        public DateTimeBox () {

            orientation = Orientation.VERTICAL;
            // set_size_request(350, 350);

            mainContainer.add(timeLabel);
            mainContainer.add(dateLabel);

            add(mainContainer);
        }

        public void setTimeFormat(bool timeTwentyFour) {

            if(timeTwentyFour)
                timeFormat = "%H:%M";
            else
                timeFormat = "%l:%M %p";



        }


        public void loadDateTime(string color, string timeLabelFont, string dateLabelFont) {


            timeout = Timeout.add(200, () => {

                var glibTime = new GLib.DateTime.now_local().format(timeFormat);
                var glibDate = new GLib.DateTime.now_local().format("%A, %B %e");

                timeLabel.set_markup(@"<span color='$color' font='$timeLabelFont'>$glibTime</span>");
                dateLabel.set_markup(@"<span color='$color' font='$dateLabelFont'>$glibDate</span>");

      
                return true;

            });


        }

        public override bool draw (Context context) {



            Cairo.Matrix matrix = Cairo.Matrix(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
            context.transform(matrix);

 

            mainContainer.draw(context);

            return true;
        }

    }
}