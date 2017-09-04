//  
//  Copyright (C) 2012-2017 Abraham Masri
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
// Copied from ManagerForKedos - Abraham Masri
// 

using Gtk;
using Gdk;
using Komorebi.Utilities;

using GLib.Environment;

namespace Komorebi.OnScreen {

    public class RowLabel : Gtk.EventBox {

    	// Switch between mainBox and 'Copied' label
    	private Stack stack = new Stack();

    	// Contains both labels
    	private Box mainBox = new Box(Orientation.HORIZONTAL, 20);

    	public Label nameLabel = new Label("Row");
    	public Label valueLabel = new Label("Value");

    	private Label copiedLabel = new Label("Copied");

    	string CSS = "*, *:disabled {
                         transition: 150ms ease-in;

                         background-color: @transparent;
                         background-image: none;
                         border: none;
                         border-color: @transparent;
                         box-shadow: inset 1px 2px rgba(0,0,0,0); 
                         border-radius: 3px;
                         color: white;
                         text-shadow:0px 2px 3px rgba(0,0,0,0.9);
                         -gtk-icon-shadow: 0px 1px 4px rgba(0, 0, 0, 0.4);

                       }

                       .:hover {
                         transition: 50ms ease-out;
                         border-style: outset;
                         background-color: rgba(0, 0, 0, 0.9);

                        }";

    	public RowLabel(string nameString) {

    		nameLabel.label = nameString;
    		copiedLabel.label = nameString + " copied";

    		margin = 10;
            add_events (EventMask.ALL_EVENTS_MASK);
            applyCSS({this}, CSS);


    		stack.set_transition_type(StackTransitionType.CROSSFADE);
    		stack.set_transition_duration(300);

            valueLabel.set_line_wrap(true);
            valueLabel.set_max_width_chars(19);
            valueLabel.set_ellipsize(Pango.EllipsizeMode.MIDDLE);

            nameLabel.set_halign(Align.START);
            valueLabel.set_halign(Align.END);

            // Signals
            button_press_event.connect(() => {

            	// Set the clipboard's value
            	clipboard.set_text (valueLabel.label, -1);

    			stack.set_visible_child(copiedLabel);

            	Timeout.add(600, () => {

    				stack.set_visible_child(mainBox);

            		return false;
            	});

            	return true;
            });


    		mainBox.pack_start(nameLabel);
    		mainBox.pack_end(valueLabel);

    		stack.add_named(mainBox, "mainBox");
    		stack.add_named(copiedLabel, "copiedLabel");

    		stack.set_visible_child(mainBox);

    		add(stack);
    	}

    	public void set_value(string valueString) {

    		valueLabel.label = valueString;
    		valueLabel.tooltip_text = valueString;
    	}
    }

}