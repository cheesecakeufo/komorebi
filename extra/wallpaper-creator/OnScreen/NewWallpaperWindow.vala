//
//  Copyright (C) 2017-2018 Abraham Masri @cheesecakeufo
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


namespace WallpaperCreator.OnScreen {

	public class NewWallpaperWindow : Gtk.Window {

		// Custom headerbar
		HeaderBar headerBar = new HeaderBar();

		Button closeButton = new Button.with_label("Close");
		Button addLayerButton = new Button.with_label("Add Layer") { visible = false };

		Button nextButton = new Button.with_label("Next");

		// Confirmation popover
		Popover popover = new Popover(null);
		Grid popoverGrid = new Grid();
		Label confirmationLabel = new Label("Are you sure?");
		Button cancelButton = new Button.with_label("Cancel");
		Button yesButton = new Button.with_label("Yes");

		Gtk.Box mainBox = new Box(Orientation.VERTICAL, 0);
			
		// Used as a display for errors
		Gtk.Revealer revealer = new Revealer();
		Gtk.InfoBar infoBar = new Gtk.InfoBar () { message_type = MessageType.ERROR };
		Gtk.Label errorLabel = new Label("");

		Stack stack = new Stack();

		OptionsPage optionsPage;

		/* Add some style */
		string CSS = "
			*{
				background-color: rgba(0, 0, 0, 0.6);
				box-shadow: none;
				color: white;
				border-width: 0px;
			}
			";

		string headerCSS = "
			*{
				background-color: rgba(0, 0, 0, 0);
				box-shadow: none;
				color: white;
				border-width: 0px;
			}
			";


		public NewWallpaperWindow () {

			title = "New Komorebi Wallpaper";
			set_size_request(1050, 700);
			resizable = false;
			window_position = WindowPosition.CENTER;
			set_titlebar(headerBar);
			applyCSS({mainBox}, CSS);
			applyCSS({headerBar}, headerCSS);
			addAlpha({this});

			// Properties
			closeButton.margin_top = 6;
			closeButton.margin_start = 6;
			closeButton.halign = Align.START;

			addLayerButton.margin_top = 6;
			addLayerButton.margin_start = 6;
			addLayerButton.halign = Align.START;

			nextButton.margin_top = 6;
			nextButton.margin_end = 6;

			popover.set_relative_to(closeButton);

			popoverGrid.margin = 15;
			popoverGrid.row_spacing = 20;
			popoverGrid.column_spacing = 5;

			revealer.set_transition_duration(200);
			revealer.set_transition_type(RevealerTransitionType.SLIDE_DOWN);

			stack.set_transition_duration(400);
			stack.set_transition_type(StackTransitionType.SLIDE_LEFT);

			// Signals
			closeButton.released.connect(() => { 
				popover.show_all();
			});

			addLayerButton.released.connect(() => {

				Gtk.FileChooserDialog fileChooseDialog = new Gtk.FileChooserDialog (
					"Select an image", this, Gtk.FileChooserAction.OPEN,
					"Cancel", Gtk.ResponseType.CANCEL,
					"Open", Gtk.ResponseType.ACCEPT
				);

				FileFilter filter = new FileFilter();
				filter.add_mime_type ("image/*");

				fileChooseDialog.set_filter (filter);

				if (fileChooseDialog.run () == Gtk.ResponseType.ACCEPT) {
					assetPath = fileChooseDialog.get_file().get_path();
					optionsPage.setAsset(assetPath);
				}

				fileChooseDialog.close ();
			});

			nextButton.released.connect(() => {

				var currentPage = stack.get_visible_child_name();

				if(currentPage == "initial") {

					if(wallpaperName == null || (wallpaperType == "image" || wallpaperType == "video") && filePath == null) {
				
						displayError("Please enter a wallpaper name and choose a file");
						return;
				
					} else if (wallpaperName == null || wallpaperType == "web_page" && webPageUrl == null) {
				
						displayError("Please enter a wallpaper name, a valid URL, and a thumbnail");
						return;
					}


					optionsPage = new OptionsPage();

					if(wallpaperType == "image") {

						addLayerButton.visible = true;
						optionsPage.setImage(filePath);

					} else {
						addLayerButton.visible = false;
						optionsPage.setImage("/System/Resources/Komorebi/blank.svg");
					}

					stack.add_named(optionsPage, "options");

					optionsPage.show_all();

					stack.set_visible_child_name("options");
					revealer.set_reveal_child(false);
				} else {

					optionsPage.updateUI();
					stack.add_named(new FinalPage(), "final");

					show_all();

					stack.set_visible_child_name("final");
					closeButton.visible = false;
					nextButton.visible = false;
					addLayerButton.visible = false;

				}

			});

			cancelButton.released.connect(() => popover.hide());
			yesButton.released.connect(() => Gtk.main_quit());

			// Add Widgets
			headerBar.add(closeButton);
			headerBar.add(addLayerButton);
			headerBar.pack_end(nextButton);

			popoverGrid.attach(confirmationLabel, 0, 0);
			popoverGrid.attach(cancelButton, 0, 1);
			popoverGrid.attach(yesButton, 1, 1);

			popover.add(popoverGrid);

			infoBar.get_content_area().add(errorLabel);
			revealer.add(infoBar);

			stack.add_named(new InitialPage(), "initial");

			mainBox.add(revealer);
			mainBox.add(stack);

			add(mainBox);
			show_all();

			// Post-Show options
			addLayerButton.visible = false;

		}

		private void displayError(string errorMessage) {

			errorLabel.label = errorMessage;
			revealer.set_reveal_child(true);
		}

	}


	/* TAKEN FROM ACIS --- Until Acis is public */
	/* Applies CSS theming for specified GTK+ Widget */
	public void applyCSS (Widget[] widgets, string CSS) {

		var Provider = new Gtk.CssProvider ();
		Provider.load_from_data (CSS, -1);

		foreach(var widget in widgets)
			widget.get_style_context().add_provider(Provider,-1);

	}


	/* TAKEN FROM ACIS --- Until Acis is public */
	/* Allow alpha layer in the window */
	public void addAlpha (Widget[] widgets) {

		foreach(var widget in widgets)
			widget.set_visual (widget.get_screen ().get_rgba_visual () ?? widget.get_screen ().get_system_visual ());

	}

}
