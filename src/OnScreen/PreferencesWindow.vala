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

using Komorebi.Utilities;

namespace Komorebi.OnScreen {

	public class PreferencesWindow : Gtk.Window {

		// Custom headerbar
		HeaderBar headerBar = new HeaderBar();

		Button hideButton = new Button.with_label("Hide");
		Button quitButton = new Button.with_label("Quit Komorebi");

		// Contains two pages (Preferences and Wallpapers)
		Gtk.Notebook notebook = new Gtk.Notebook();

		// Contains preferences page widgets
		Gtk.Box preferencesPage = new Box(Orientation.VERTICAL, 5);

		Gtk.Grid aboutGrid = new Gtk.Grid();

		Box titleBox = new Box(Orientation.VERTICAL, 5);
		Label titleLabel = new Label("");
		Label aboutLabel = new Label("");

		Gtk.CheckButton twentyFourHoursButton = new Gtk.CheckButton.with_label ("Use 24-hour time");
		Gtk.CheckButton showDesktopIconsButton = new Gtk.CheckButton.with_label ("Show desktop icons");
		Gtk.CheckButton enableVideoWallpapersButton = new Gtk.CheckButton.with_label ("Enable Video Wallpapers (Restarting Komorebi is required)");

		Gtk.Box bottomPreferencesBox = new Box(Orientation.HORIZONTAL, 10);

		Button donateButton = new Button.with_label("Donate");
		Button reportButton = new Button.with_label("Report an issue");

		// Contains wallpapers page widgets
		Gtk.Box wallpapersPage = new Box(Orientation.VERTICAL, 10);

		Gtk.InfoBar infoBar = new Gtk.InfoBar ();

		WallpapersSelector wallpapersSelector = new WallpapersSelector();

		Gtk.Box bottomWallpapersBox = new Box(Orientation.HORIZONTAL, 10);

		Label currentWallpaperLabel = new Label("");

		// Triggered when pointer leaves window
		bool canDestroy = false;


		/* Add some style */
		string notebookCSS = "
			*{
				background: none;
				background-color: rgba(0, 0, 0, 0.60);
				box-shadow: none;
				color: white;
				border-width: 0;
			}
			.notebook.header {
				background-color: rgb(0,0,0);
			}
			.notebook notebook:focus tab {
				background: none;
				border-width: 0;
				border-radius: 0px;
				border-color: transparent;
				border-image-width: 0;
				border-image: none;
				background-color: red;
			}
			";

		string headerCSS = "
			*{
				background: rgba(0, 0, 0, 0.7);
				background-color: rgb(0, 0, 0);
				box-shadow: none;
				color: white;
				border-width: 0px;
				box-shadow: none;
				border-image: none;
				border: none;
			}
			";

		string infoBarCSS = "
			*{
				background: #f44336;
				background-color: #f44336;
				box-shadow: none;
				color: white;
				border-width: 0px;
				box-shadow: none;
				border-image: none;
				border: none;
			}
			";
		public PreferencesWindow (string selectedTab = "preferences") {

			title = "";
			set_size_request(760, 500);
			resizable = false;
			window_position = WindowPosition.CENTER;
			set_titlebar(headerBar);
			applyCSS({this.notebook}, notebookCSS);
			applyCSS({this.infoBar}, infoBarCSS);
			applyCSS({headerBar, hideButton, quitButton, donateButton, reportButton}, headerCSS);
			addAlpha({this});

			// Setup Widgets
			titleLabel.set_markup("<span font='Lato Light 30px' color='white'>Komorebi</span>");
			aboutLabel.set_markup("<span font='Lato Light 15px' color='white'>by Abraham Masri @cheesecakeufo</span>");

			// showSystemStatsButton.active = showInfoBox;
			twentyFourHoursButton.active = timeTwentyFour;
			showDesktopIconsButton.active = showDesktopIcons;
			enableVideoWallpapersButton.active = enableVideoWallpapers;

			setWallpaperNameLabel();

			// Properties
			hideButton.margin_top = 6;
			hideButton.margin_start = 6;
			hideButton.halign = Align.START;

			quitButton.margin_top = 6;
			quitButton.margin_end = 6;

			notebook.expand = true;

			preferencesPage.margin = 20;
			preferencesPage.halign = Align.CENTER;
			preferencesPage.margin_bottom = 10;

			aboutGrid.halign = Align.CENTER;
			aboutGrid.margin_bottom = 30;
			aboutGrid.column_spacing = 0;
			aboutGrid.row_spacing = 0;

			titleBox.margin_top = 15;
			titleBox.margin_start = 10;
			titleLabel.halign = Align.START;

			bottomPreferencesBox.margin_top = 10;

			donateButton.valign = Align.CENTER;
			reportButton.valign = Align.CENTER;

			infoBar.message_type = MessageType.WARNING;
			infoBar.set_show_close_button(false);

			currentWallpaperLabel.selectable = true;

			bottomWallpapersBox.margin = 25;
			bottomWallpapersBox.margin_top = 10;

			// Signals
			destroy.connect(() => { canOpenPreferences = true;});

			hideButton.released.connect(() => { destroy(); });
			quitButton.released.connect(() => {

				print("Quitting Komorebi. Good bye :)\n");
				Clutter.main_quit();

			});

			donateButton.released.connect(() => {

				print("Thank you <3\n");
				AppInfo.launch_default_for_uri("https://goo.gl/Yr1RQe", null); // Thank you <3
				destroy();

			});

			reportButton.released.connect(() => {

				AppInfo.launch_default_for_uri("https://goo.gl/aaJgN7", null);
				destroy();
			});


			twentyFourHoursButton.toggled.connect (() => {

				timeTwentyFour = twentyFourHoursButton.active;
				updateConfigurationFile();

			});

			showDesktopIconsButton.toggled.connect (() => { 
				showDesktopIcons = showDesktopIconsButton.active;
				updateConfigurationFile();

				if (showDesktopIcons) {
					foreach (BackgroundWindow backgroundWindow in backgroundWindows)
						backgroundWindow.desktopIcons.fadeIn();
				} else {
					foreach (BackgroundWindow backgroundWindow in backgroundWindows)
						backgroundWindow.desktopIcons.fadeOut();
				}
			});

			enableVideoWallpapersButton.toggled.connect (() => {

				enableVideoWallpapers = enableVideoWallpapersButton.active;
				updateConfigurationFile();

			});

			wallpapersSelector.wallpaperChanged.connect(() => {
				setWallpaperNameLabel();
			});

			// Add Widgets
			headerBar.add(hideButton);
			headerBar.pack_end(quitButton);

			titleBox.add(titleLabel);
			titleBox.add(aboutLabel);

			aboutGrid.attach(new Image.from_file("/System/Resources/Komorebi/komorebi.svg"), 0, 0, 1, 1);
			aboutGrid.attach(titleBox, 1, 0, 1, 1);

			bottomPreferencesBox.pack_start(donateButton);
			bottomPreferencesBox.pack_end(reportButton);

			preferencesPage.add(aboutGrid);
			preferencesPage.add(twentyFourHoursButton);
			preferencesPage.add(showDesktopIconsButton);
			preferencesPage.add(enableVideoWallpapersButton);
			preferencesPage.pack_end(bottomPreferencesBox);

			bottomWallpapersBox.add(new Image.from_file("/System/Resources/Komorebi/info.svg"));
			bottomWallpapersBox.add(currentWallpaperLabel);

			if(!canPlayVideos()) {

				infoBar.get_content_area().add(new Label("gstreamer1.0-libav is missing. You won't be able to set video wallpapers without it."));
				wallpapersPage.add(infoBar);
			}

			wallpapersPage.add(wallpapersSelector);
			wallpapersPage.add(bottomWallpapersBox);


			if(selectedTab == "wallpapers") {
				notebook.append_page(wallpapersPage, new Label("Wallpapers"));
				notebook.append_page(preferencesPage, new Label("Preferences"));
			} else {
				notebook.append_page(preferencesPage, new Label("Preferences"));
				notebook.append_page(wallpapersPage, new Label("Wallpapers"));
			}


			notebook.child_set_property (preferencesPage, "tab-expand", true);
			notebook.child_set_property (wallpapersPage, "tab-expand", true);

			add(notebook);

			show_all();
		}

		/* Changes the wallpaper name label */
		private void setWallpaperNameLabel() {

			var prettyName = beautifyWallpaperName(wallpaperName);
			currentWallpaperLabel.set_markup(@"<span font='Lato Light 15px' color='#bebebee6'>$prettyName</span>");
		}

		/* Shows the window */
		public void FadeIn() {

			show_all();

		}

	}
}
