//
//  Copyright (C) 2020 Komorebi Team Authors
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

namespace Komorebi.Paths {

	string[] wallpaperPaths;

	/* Returns the path for hosting configuration files and wallpapers */
	public string getConfigDir() {

		string basePath = Environment.get_variable ("XDG_CONFIG_HOME");

		if(basePath == null) {
			basePath = GLib.Path.build_filename(Environment.get_home_dir(), ".config");

			if(basePath == null)
				basePath = Environment.get_home_dir();
		}

		return GLib.Path.build_filename(basePath, "komorebi");
	}

	/* Returns the list of paths to search for wallpapers */
	public string[] getWallpaperPaths() {
		if(wallpaperPaths == null) {
			wallpaperPaths = {
				GLib.Path.build_filename(getConfigDir(), "wallpapers"),
				Config.package_datadir
			};
		}

		return wallpaperPaths;
	}
}
