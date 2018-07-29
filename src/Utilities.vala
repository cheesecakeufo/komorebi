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

using Komorebi.OnScreen;

namespace Komorebi.Utilities {

	// Komorebi variables
	string desktopPath;
	string configFilePath;
	File configFile;
	KeyFile configKeyFile;

	// Screen variables
	int screenHeight;
	int screenWidth;

	// Icons variables
	int iconSize;

	// DateTime variables
	bool dateTimeParallax;
	bool dateTimeVisible;

	int dateTimeMarginTop;
	int dateTimeMarginRight;
	int dateTimeMarginLeft;
	int dateTimeMarginBottom;

	double dateTimeRotationX;
	double dateTimeRotationY;
	double dateTimeRotationZ;

	string dateTimePosition;
	string dateTimeAlignment;
	bool dateTimeAlwaysOnTop;

	string dateTimeColor;
	int dateTimeAlpha;

	string dateTimeShadowColor;
	int dateTimeShadowAlpha;

	string dateTimeTimeFont;
	string dateTimeDateFont;

	// Wallpaper variables
	KeyFile wallpaperKeyFile;

	string wallpaperType;
	string videoFileName;
	string webPageUrl;

	bool wallpaperParallax;

	// Asset variables
	bool assetVisible;

	int assetWidth;
	int assetHeight;

	string assetAnimationMode;
	int assetAnimationSpeed;

	string assetPosition;

	int assetMarginTop;
	int assetMarginRight;
	int assetMarginLeft;
	int assetMarginBottom;



	/* Returns an icon detected from file, IconTheme, etc .. */
	public Pixbuf getIconFrom (string icon, int size) {

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

	/* Formats the date and time into a human read-able version */
	public string formatDateTime (DateTime dateTime) {

		if (OnScreen.timeTwentyFour)
			return dateTime.format("%m/%d/%Y %H:%M");

		return dateTime.format("%m/%d/%Y %l:%M %p");
	}

	/* Reads the .prop file */
	public void readConfigurationFile () {

		// Default values
		wallpaperName = "foggy_sunny_mountain";
		timeTwentyFour = true;
		showDesktopIcons = true;
		enableVideoWallpapers = true;

		if(configFilePath == null)
			configFilePath = Environment.get_home_dir() + "/.Komorebi.prop";

		if(configFile == null)
			configFile = File.new_for_path(configFilePath);

		if(configKeyFile == null)
			configKeyFile = new KeyFile ();

		if(!configFile.query_exists()) {
			print("No configuration file found. Creating one..\n");
			updateConfigurationFile();
			return;
		}

		print("Reading config file..\n");

		configKeyFile.load_from_file(configFilePath, KeyFileFlags.NONE);

		var key_file_group = "KomorebiProperties";

		// make sure the config file has the required values
		if(!configKeyFile.has_group(key_file_group) ||
			!configKeyFile.has_key(key_file_group, "WallpaperName") ||
			!configKeyFile.has_key(key_file_group, "TimeTwentyFour") ||
			!configKeyFile.has_key(key_file_group, "ShowDesktopIcons") ||
			!configKeyFile.has_key(key_file_group, "EnableVideoWallpapers")) {
			
			print("[WARNING]: invalid configuration file found. Fixing..\n");
			updateConfigurationFile();
			return;
		}


		wallpaperName = configKeyFile.get_string (key_file_group, "WallpaperName");
		timeTwentyFour = configKeyFile.get_boolean (key_file_group, "TimeTwentyFour");
		showDesktopIcons = configKeyFile.get_boolean (key_file_group, "ShowDesktopIcons");
		enableVideoWallpapers = configKeyFile.get_boolean (key_file_group, "EnableVideoWallpapers");
		fixConflicts();
	}

	/* Updates the .prop file */
	public void updateConfigurationFile () {

		var key_file_group = "KomorebiProperties";

		configKeyFile.set_string  (key_file_group, "WallpaperName", wallpaperName);
		configKeyFile.set_boolean (key_file_group, "TimeTwentyFour", timeTwentyFour);
		configKeyFile.set_boolean (key_file_group, "ShowDesktopIcons", showDesktopIcons);
		configKeyFile.set_boolean (key_file_group, "EnableVideoWallpapers", enableVideoWallpapers);

		// Delete the file
		if(configFile.query_exists())
			configFile.delete();

		// save the key file
		var stream = new DataOutputStream (configFile.create (0));
		stream.put_string (configKeyFile.to_data ());
		stream.close ();

	}

	/* Fixes conflicts with other environmnets */
	void fixConflicts() {

		// Disable/Enabled nautilus to fix bug when clicking on another monitor
		new GLib.Settings("org.gnome.desktop.background").set_boolean("show-desktop-icons", false);

		// Check if we have nemo installed
		SettingsSchemaSource settingsSchemaSource = new SettingsSchemaSource.from_directory ("/usr/share/glib-2.0/schemas", null, false);
		SettingsSchema settingsSchema = settingsSchemaSource.lookup ("org.nemo.desktop", false);

		if (settingsSchema != null)
			// Disable/Enable Nemo's desktop icons
			new GLib.Settings("org.nemo.desktop").set_boolean("show-desktop-icons", false);


	}

	void readWallpaperFile () {

		// check if the wallpaper exists
		// also, make sure the wallpaper name is valid
		var wallpaperPath = @"/System/Resources/Komorebi/$wallpaperName";
		var wallpaperConfigPath = @"$wallpaperPath/config";

		if(wallpaperName == null || !File.new_for_path(wallpaperPath).query_exists() ||
			!File.new_for_path(wallpaperConfigPath).query_exists()) {

			wallpaperName = "foggy_sunny_mountain";
			wallpaperPath = @"/System/Resources/Komorebi/$wallpaperName";
			wallpaperConfigPath = @"$wallpaperPath/config";

			print(@"[ERROR]: got an invalid wallpaper. Setting to default: $wallpaperName\n");
		}

		// init the wallpaperKeyFile (if we haven't already)
		if(wallpaperKeyFile == null)
			wallpaperKeyFile = new KeyFile ();

		// Read the config file
		wallpaperKeyFile.load_from_file(wallpaperConfigPath, KeyFileFlags.NONE);

		// Wallpaper Info
		wallpaperType = wallpaperKeyFile.get_string("Info", "WallpaperType");

		// DateTime
		dateTimeVisible = wallpaperKeyFile.get_boolean ("DateTime", "Visible");
		dateTimeParallax = wallpaperKeyFile.get_boolean ("DateTime", "Parallax");

		dateTimeMarginLeft = wallpaperKeyFile.get_integer ("DateTime", "MarginLeft");
		dateTimeMarginTop = wallpaperKeyFile.get_integer ("DateTime", "MarginTop");
		dateTimeMarginBottom = wallpaperKeyFile.get_integer ("DateTime", "MarginBottom");
		dateTimeMarginRight = wallpaperKeyFile.get_integer ("DateTime", "MarginRight");

		dateTimeRotationX = wallpaperKeyFile.get_double ("DateTime", "RotationX");
		dateTimeRotationY = wallpaperKeyFile.get_double ("DateTime", "RotationY");
		dateTimeRotationZ = wallpaperKeyFile.get_double ("DateTime", "RotationZ");

		dateTimePosition = wallpaperKeyFile.get_string ("DateTime", "Position");
		dateTimeAlignment = wallpaperKeyFile.get_string ("DateTime", "Alignment");
		dateTimeAlwaysOnTop = wallpaperKeyFile.get_boolean ("DateTime", "AlwaysOnTop");

		dateTimeColor = wallpaperKeyFile.get_string ("DateTime", "Color");
		dateTimeAlpha = wallpaperKeyFile.get_integer ("DateTime", "Alpha");

		dateTimeShadowColor = wallpaperKeyFile.get_string ("DateTime", "ShadowColor");
		dateTimeShadowAlpha = wallpaperKeyFile.get_integer ("DateTime", "ShadowAlpha");

		dateTimeTimeFont = wallpaperKeyFile.get_string ("DateTime", "TimeFont");
		dateTimeDateFont = wallpaperKeyFile.get_string ("DateTime", "DateFont");


		if(wallpaperType == "video") {
			videoFileName = wallpaperKeyFile.get_string("Info", "VideoFileName");
			wallpaperParallax = assetVisible = false;
			return;
		}

		if(wallpaperType == "web_page") {
			webPageUrl = wallpaperKeyFile.get_string("Info", "WebPageUrl");
			wallpaperParallax = assetVisible = false;

			return;
		}

		// Wallpaper base image
		wallpaperParallax = wallpaperKeyFile.get_boolean("Wallpaper", "Parallax");

		// Asset
		assetVisible = wallpaperKeyFile.get_boolean ("Asset", "Visible");

		assetAnimationMode = wallpaperKeyFile.get_string ("Asset", "AnimationMode");
		assetAnimationSpeed = wallpaperKeyFile.get_integer ("Asset", "AnimationSpeed");

		assetWidth = wallpaperKeyFile.get_integer ("Asset", "Width");
		assetHeight = wallpaperKeyFile.get_integer ("Asset", "Height");

		// Set GNOME's wallpaper to this
		var wallpaperJpgPath = @"/System/Resources/Komorebi/$wallpaperName/wallpaper.jpg";
		new GLib.Settings("org.gnome.desktop.background").set_string("picture-uri", ("file://" + wallpaperJpgPath));
		new GLib.Settings("org.gnome.desktop.background").set_string("picture-options", "stretched");
	}


	/* Creates a new folder in desktop */
	public void createNewFolder(string name, int number = 0) {

		File newFolder;

		if(number > 0)
			newFolder = File.new_for_path(desktopPath + @"/$name ($(number.to_string()))");
		else
			newFolder = File.new_for_path(desktopPath + @"/$name");

		if(newFolder.query_exists())
			createNewFolder(name, number + 1);
		else
			newFolder.make_directory_async();

	}

	/* Beautifies the name of the wallpaper */
	public string beautifyWallpaperName (string wallpaperName) {

		var resultString = "";

		foreach(var word in wallpaperName.split("_")) {
			resultString += (word.@get(0).to_string().up() + word.substring(1).down() + " ");
		}

		return resultString;

	}

	/* A dirty way to check if gstreamer is installed */
	public bool canPlayVideos() {

		if(	File.new_for_path("/usr/lib/gstreamer-1.0/libgstlibav.so").query_exists() ||
			File.new_for_path("/usr/lib64/gstreamer-1.0/libgstlibav.so").query_exists() ||
			File.new_for_path("/usr/lib/i386-linux-gnu/gstreamer-1.0/libgstlibav.so").query_exists() ||
			File.new_for_path("/usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstlibav.so").query_exists())
			return true;

		return false;
	}
}
