Name: komorebi
Version: 2.2.1
Release: 1%{?dist}
Summary: A beautiful and customizable wallpaper manager for Linux
License: GPL-3.0

URL: https://github.com/Komorebi-Fork/komorebi
Source0: %{name}-%{version}.tar.xz

BuildRequires: meson
BuildRequires: vala
BuildRequires: gcc
BuildRequires: pkgconfig(glib-2.0)
BuildRequires: pkgconfig(gobject-2.0)
BuildRequires: pkgconfig(gtk+-3.0)
BuildRequires: pkgconfig(gee-0.8)
BuildRequires: pkgconfig(webkit2gtk-4.0)
BuildRequires: pkgconfig(clutter-gtk-1.0)
BuildRequires: pkgconfig(clutter-1.0)
BuildRequires: pkgconfig(clutter-gst-3.0)

%description
Komorebi is an awesome animated wallpaper manager for all Linux platforms. It provides fully customizeable image, video, and web page wallpapers that can be tweaked at any time!

%prep
%autosetup

%build
%meson
%meson_build

%install
%meson_install

%check
%meson_test

%files
/usr/bin/komorebi
/usr/bin/komorebi-wallpaper-creator
/usr/share/applications/org.komorebiteam.komorebi.desktop
/usr/share/applications/org.komorebiteam.wallpapercreator.desktop
/usr/share/fonts/AmaticSC-Regular.ttf
/usr/share/fonts/Bangers-Regular.ttf
/usr/share/fonts/BubblerOne-Regular.ttf
/usr/share/fonts/Lato-Hairline.ttf
/usr/share/fonts/Lato-Light.ttf
/usr/share/fonts/VT323-Regular.ttf
/usr/share/komorebi
/usr/share/metainfo/org.komorebiteam.komorebi.appdata.xml
/usr/share/metainfo/org.komorebiteam.wallpapercreator.appdata.xml
/usr/share/pixmaps/komorebi

%changelog
* Sun Aug 30 2020 meson <meson@example.com> -
-
