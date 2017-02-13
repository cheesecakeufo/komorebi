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
// Copied from Acis - Abraham Masri
// 

using Gtk;
using Gdk;
using GLib;
using Cairo;

namespace Komorebi.Utilities {

	/* Returns an icon detected from file, IconTheme, etc .. */
	public Pixbuf GetIconFrom (string icon, int size) {

		Pixbuf IconPixbuf = null;

		if(icon == null || icon == "")
			return IconPixbuf;

		/* Try those methods:
		 * 1- Icon is a file, somewhere in '/'.
		 * 2- Icon is an icon in a IconTheme.
		 * 3- Icon isn't in the current IconTheme.
		 * 4- Icon is not available, use default.
		 */
		if(File.new_for_path(icon).query_exists()) {
			IconPixbuf = new Pixbuf.from_file_at_scale(icon, size, size, false);
			return IconPixbuf;
		}

		
		Gtk.IconTheme _IconTheme = Gtk.IconTheme.get_default ();
		_IconTheme.prepend_search_path("/usr/share/pixmaps/");


		try {

			IconPixbuf = _IconTheme.load_icon (icon, size, IconLookupFlags.FORCE_SIZE);


		} catch (Error e) {


			if(IconPixbuf == null)
				IconPixbuf = _IconTheme.load_icon ("application-default-icon", size, IconLookupFlags.FORCE_SIZE);


		}


		return IconPixbuf;

	}

}