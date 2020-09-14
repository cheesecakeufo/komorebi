project('komorebi', 'vala', 'c',
    version: '2.2.1',
    meson_version: '>=0.49',
)

# Internationalisation / Localisation. This is currently only used to configure the .desktop files;
i18n = import('i18n')
po_dir = meson.source_root() / 'po'
gettext_package = meson.project_name()
add_project_arguments('-DGETTEXT_PACKAGE=' + gettext_package, language: 'c')
i18n.gettext(meson.project_name(),
    args: '--directory=' + meson.source_root()
)

# Set some variables
prefix = get_option('prefix')
bindir = get_option('bindir')
datadir = get_option('datadir')
pkgdatadir = join_paths(prefix, datadir, meson.project_name())

# Configure Komorebi
conf = configuration_data()
conf.set_quoted('PACKAGE_NAME', meson.project_name())
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('PKGDATADIR', pkgdatadir)
conf.set_quoted('DATADIR', join_paths(prefix, datadir))
komorebiconfiguration = configure_file(input: 'config.vala.in', output: 'config.vala', configuration: conf)

# Compile resources (images, etc,) so that they're built into the app.
# TODO: Generate separate resource bundles for Komorebi & Wallpaper Creator;
# There's enough overlap that I'm not going to do it right now, but it'd be more elegant.
gnome = import('gnome')
komorebiresources = gnome.compile_resources(
    'as-resources', 'data/resources/komorebi.gresource.xml',
    source_dir: 'data/resources',
    c_name: 'as'
)

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

main_sources = []
wallpaper_sources = []

wallpaper_sources += files('src/Paths.vala')

subdir('src')
subdir('wallpaper-creator')
subdir('data')

# Postinst script needs work. Let's not run it blindly.
# Frankly, I doubt that there's many (any?) users that have yet to update wallpapers to the new format, so maybe do away with it?
#meson.add_install_script('data/Other/postinst')

executable(meson.project_name(), main_sources, komorebiconfiguration, komorebiresources,
    dependencies: dependencies,
    install: true
)

executable(meson.project_name() + '-wallpaper-creator', wallpaper_sources, komorebiconfiguration, komorebiresources,
    dependencies: dependencies,
    install: true
)
