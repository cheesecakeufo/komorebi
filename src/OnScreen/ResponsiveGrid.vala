//
//  Copyright (C) 2016-2017 Abarham Masri
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
// 
// Copied from Acis - Abraham Masri
// 

using Gtk;

namespace Komorebi.OnScreen {

    public class ResponsiveGrid : Gtk.Grid {

        /* Append type */
        public enum Type {
            COLUMN,
            ROW
        }

        int Row = 0;
        int Column = 0;

        // Limit of items per column/row
        public int EdgeLimit = 3;

        public Type appendType = Type.COLUMN;

        public ResponsiveGrid (Type appendType = Type.COLUMN) {

            this.appendType = appendType;
            row_spacing = 14;
        }

        /* Set the edge limit */
        public void setEdgeLimit (int limit) {

            EdgeLimit = limit;

        }

        public void append (Widget widget) {

            attach (widget, Column, Row, 1, 1);

            switch(appendType) {

                case appendType.COLUMN:
                    if(Column == EdgeLimit) {
                        Row++;
                        Column = 0;
                    } else
                        Column++;
                break;

                case appendType.ROW:
                    if(Row == EdgeLimit) {
                        Column++;
                        Row = 0;
                    } else
                        Row++;
                break;

            }



        }

        public void clear () {

            foreach (Widget widget in get_children ())
                remove(widget);

            Column = 0;
            Row = 0;

        }
    }
}
