//
//  Copyright (C) 2020 Komorebi Team Authors
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
using Komorebi.Paths;

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
	string wallpaperPath;
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

	bool autostart;

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
		mutePlayback = false;
		pausePlayback = true;
		autostart = false;

		if(configFilePath == null)
			configFilePath = GLib.Path.build_filename(getConfigDir(), "komorebi.prop");

		if(configFile == null)
			configFile = File.new_for_path(configFilePath);

		if(configKeyFile == null)
			configKeyFile = new KeyFile ();

		if(!configFile.query_exists()) {
			bootstrapConfigPath();
			if(!configFile.query_exists()) {
				print("No configuration file found. Creating one..\n");
				updateConfigurationFile();
				return;
			}
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
		if (configKeyFile.has_key(key_file_group, "MutePlayback")) {
			mutePlayback = configKeyFile.get_boolean(key_file_group, "MutePlayback");
		} else {
			mutePlayback = false;
		}
		if (configKeyFile.has_key(key_file_group, "PausePlayback")) {
			pausePlayback = configKeyFile.get_boolean(key_file_group, "PausePlayback");
		} else {
			pausePlayback = true;
		}
		if (configKeyFile.has_key(key_file_group, "Autostart")) {
			autostart = configKeyFile.get_boolean(key_file_group, "Autostart");
		} else {
			autostart = false;
		}
		fixConflicts();
	}

	/* Bootstraps the base configuration path if it doesn't exist, and detects older versions of this app */
	public void bootstrapConfigPath() {
		File configPath = File.new_build_filename(getConfigDir(), "wallpapers");
		if(!configPath.query_exists())
			configPath.make_directory_with_parents();

		// If it can find an older config file, copy it to the new directory
		File oldConfigFile = File.new_build_filename(Environment.get_home_dir(), ".Komorebi.prop");
		if(oldConfigFile.query_exists()) {
			print("Found config file from old version, converting it to new one...\n");
			File destinationPath = File.new_build_filename(getConfigDir(), "komorebi.prop");
			oldConfigFile.copy(destinationPath, FileCopyFlags.NONE);
		}

		configFile = File.new_for_path(configFilePath);
	}

	/* Updates the .prop file */
	public void updateConfigurationFile () {

		var key_file_group = "KomorebiProperties";

		configKeyFile.set_string  (key_file_group, "WallpaperName", wallpaperName);
		configKeyFile.set_boolean (key_file_group, "TimeTwentyFour", timeTwentyFour);
		configKeyFile.set_boolean (key_file_group, "ShowDesktopIcons", showDesktopIcons);
		configKeyFile.set_boolean (key_file_group, "EnableVideoWallpapers", enableVideoWallpapers);
		configKeyFile.set_boolean(key_file_group, "MutePlayback", mutePlayback);
		configKeyFile.set_boolean(key_file_group, "PausePlayback", pausePlayback);
		configKeyFile.set_boolean(key_file_group, "Autostart", autostart);

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
		string wallpaperConfigPath = "";
		bool wallpaperFound = false;

		// Populates the wallpaper path list
		getWallpaperPaths();

		for(int i = 0; i < wallpaperPaths.length; i++) {
			wallpaperPath = @"$(wallpaperPaths[i])/$wallpaperName";
			wallpaperConfigPath = @"$wallpaperPath/config";

			if(wallpaperName == null || !File.new_for_path(wallpaperPath).query_exists() ||
				!File.new_for_path(wallpaperConfigPath).query_exists())
				continue;

			wallpaperFound = true;
			break;
		}

		if(!wallpaperFound) {
			wallpaperName = "foggy_sunny_mountain";
			wallpaperPath = @"$(Config.package_datadir)/$wallpaperName";
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
			File.new_for_path("/usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstlibav.so").query_exists() ||
			File.new_for_path("/usr/lib/arm-linux-gnueabihf/gstreamer-1.0/libgstlibav.so").query_exists())
			return true;

		return false;
	}

	public void enableAutostart() {
		var desktopFileName = "org.komorebiteam.komorebi.desktop";
		File desktopFile = File.new_build_filename(Config.datadir, "applications", desktopFileName);
		if(!desktopFile.query_exists()) {
			print("[WARNING] Desktop file not found, autostart won't work!");
			return;
		}

		string[] destPaths = {Environment.get_variable("XDG_CONFIG_HOME"), GLib.Path.build_filename(Environment.get_home_dir(), ".config")};

		foreach(string path in destPaths) {
			if(path == null || !File.new_for_path(path).query_exists())
				continue;

			File destFile = File.new_build_filename(path, "autostart", desktopFileName);
			desktopFile.copy(destFile, FileCopyFlags.NONE);
			return;
		}

		print("[WARNING] Couldn't find any user directory config, autostart won't work!");
	}

	public void disableAutostart() {
		var desktopFileName = "org.komorebiteam.komorebi.desktop";
		string[] destPaths = {Environment.get_variable("XDG_CONFIG_HOME"), GLib.Path.build_filename(Environment.get_home_dir(), ".config")};

		foreach(string path in destPaths) {
			if(path == null || !File.new_for_path(path).query_exists())
				continue;

			File desktopFile = File.new_build_filename(path, "autostart", desktopFileName);
			desktopFile.delete();
			return;
		}
	}

	/* A quick way to find a given arg from the args list */
	public bool hasArg(string arg, string[] args) {
		foreach(string s in args) {
			if(s == arg)
				return true;
		}

		return false;
	}
}
