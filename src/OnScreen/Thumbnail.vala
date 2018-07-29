//
//  Copyright (C) 2012-2013 Abraham Masri @cheesecakeufo
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

using Komorebi.Utilities;

namespace Komorebi.OnScreen {

	private class Thumbnail : EventBox {

		string name = "";

		Overlay overlay = new Overlay();
		Image thumbnailImage = new Image();
		Image borderImage = new Image.from_file("/System/Resources/Komorebi/thumbnail_border.svg");
		Revealer revealer = new Revealer();

		// Signaled when clicked
		public signal void clicked ();

		construct {

			add_events (Gdk.EventMask.BUTTON_RELEASE_MASK);

			revealer.set_transition_duration(200);
			revealer.set_transition_type(RevealerTransitionType.CROSSFADE);


			overlay.add(thumbnailImage);
			overlay.add_overlay(revealer);
			add(overlay);
		}

		public Thumbnail (string path, string name) {

			this.name = name;

			thumbnailImage.pixbuf = new Gdk.Pixbuf.from_file_at_scale(path + name + "/wallpaper.jpg", 150, 100, false);

			// Signals
			button_release_event.connect(() => {
				
				wallpaperName = name;
				showBorder();
				clicked();
				
				readWallpaperFile();
				updateConfigurationFile();

				foreach (BackgroundWindow backgroundWindow in backgroundWindows)
					backgroundWindow.initializeConfigFile();


				foreach(var thumbnail in thumbnailsList)
					if(thumbnail.name != name)
						thumbnail.hideBorder();

				return true;
			});

			revealer.set_reveal_child((wallpaperName == name));

			// Add widgets
			revealer.add(borderImage);
		}


		public Thumbnail.Add() {

			thumbnailImage.pixbuf = new Gdk.Pixbuf.from_file_at_scale("/System/Resources/Komorebi/thumbnail_add.svg", 150, 100, false);

		}


		/* Shows the border */
		public void showBorder () {

			revealer.set_reveal_child(true);

		}

		/* Hides the border */
		public void hideBorder () {

			revealer.set_reveal_child(false);
		}
	}
}