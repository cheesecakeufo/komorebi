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

        // Contains info widgets
        Gtk.Box infoContainer = new Box(Orientation.HORIZONTAL, 5);

        // RAM Image and label
        Gtk.Image ramImage = new Image();
        Gtk.Label ramLabel = new Label("1.5/4.0GB");

        // Time updater
        public uint timeout;

        public DateTimeBox () {

            orientation = Orientation.VERTICAL;
            // set_size_request(350, 350);

            infoContainer.add(ramImage);
            infoContainer.add(ramLabel);

            mainContainer.add(timeLabel);
            mainContainer.add(dateLabel);
            mainContainer.add(infoContainer);

            add(mainContainer);
        }


        void initInfoWidgets () {

            ramLabel.set_markup(@"<span color='white' font='Lato Regular 15'>1.5/4.0GB</span>");


        }


        public void loadDateTime(string color, string timeLabelFont, string dateLabelFont) {


            timeout = Timeout.add(200, () => {

                var glibTime = new GLib.DateTime.now_local().format("%l:%M %p");
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