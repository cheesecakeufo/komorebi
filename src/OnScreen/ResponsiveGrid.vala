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

using Clutter;

namespace Komorebi.OnScreen {

    public class ResponsiveGrid : Actor {

        // Limit of items per column
        public int itemsLimit = 8;

        // Layouts (HORIZONTAL/VERTICAL)
        internal BoxLayout horizontalLayout = new BoxLayout() {orientation = Clutter.Orientation.HORIZONTAL, spacing = 50};
        internal BoxLayout verticalLayout = new BoxLayout() {orientation = Clutter.Orientation.VERTICAL, spacing = 30};

        public ResponsiveGrid () {

            layout_manager = horizontalLayout;
            y_align = ActorAlign.START;
        }

        public void append (Actor item) {

            if(last_child != null)
                if(last_child.get_n_children() < itemsLimit) {
                    last_child.add_child (item);
                    return;
                }


            // Create a new column and add the new item to it
            var columnActor = new Actor() {layout_manager = verticalLayout, y_align = ActorAlign.START, y_expand = true};

            columnActor.add_child(item);
            add_child(columnActor);
        }

        public void clearIcons () {

            foreach (var child in get_children()) {
                child.destroy_all_children();
                remove_child(child);
            }

        }
    }
}
