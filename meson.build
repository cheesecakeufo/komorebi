project('komorebi', 'vala', 'c', version: '2.2.0', meson_version: '>=0.49', default_options: ['prefix=/usr'])

as_version = meson.project_version()
ver_arr = as_version.split('.')

as_major_version = ver_arr[0]
as_minor_version = ver_arr[1]
as_micro_version = ver_arr[2]

i18n = import('i18n')
po_dir = meson.source_root() / 'po'
gettext_package = meson.project_name()
add_project_arguments('-DGETTEXT_PACKAGE=' + gettext_package, language: 'c')

prefix = get_option('prefix') # should be /usr
bindir = get_option('bindir') # should be bin
datadir = get_option('datadir') # should be /usr/share


dependencies = [
      dependency('glib-2.0', version: '>=2.38'),
      dependency('gobject-2.0'),
      dependency('gtk+-3.0', version: '>=3.14'),
      dependency('gee-0.8'),
      dependency('webkit2gtk-4.0'),
      dependency('clutter-gtk-1.0'),
      dependency('clutter-1.0'),
      dependency('clutter-gst-3.0'),

]

subdir('src')
subdir('wallpaper-creator')
subdir('data')

meson.add_install_script('data/Other/postinst')
