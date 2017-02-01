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

    public class InfoBox: Box {

        // Labels box
        Gtk.Box mainContainer = new Box(Orientation.HORIZONTAL, 5);

        // RAM Image and label
        Gtk.Image ramImage = new Image();
        Gtk.Label ramLabel = new Label("1.5/4.0GB");

        // Time updater
        public uint timeout;

        public InfoBox () {

            orientation = Orientation.VERTICAL;
            margin = 30;

            initInfoWidgets();

            add(ramImage);
            add(ramLabel);
        }


        void initInfoWidgets () {

            Timeout.add(500, () => {

                /* Memory */
                GTop.Mem mem;
                GTop.get_mem (out mem);
                var mem_usage = ("%.1lf", Math.round((float) (mem.total / 1073741824)));

                ramLabel.set_markup(@"<span color='white' font='Lato Regular 15'>$mem_usage</span>");

                return true;
            });

        }


    }
}