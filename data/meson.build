# Setup configuration data for .desktop entries
desktop_conf = configuration_data()
desktop_conf.set('bindir', prefix / bindir)
desktop_conf.set('datadir', prefix / datadir)
desktop_conf.set('projectname', meson.project_name())

# Configure desktop entry and do any internationalisation
foreach desktop_file: [ 'org.komorebiteam.komorebi.desktop', 'org.komorebiteam.wallpapercreator.desktop' ]
  i18n_file = configure_file(
    input: 'Other' / desktop_file + '.in',
    output: desktop_file + '.i18n',
    configuration: desktop_conf
  )
  i18n.merge_file(
    input: i18n_file,
    output: desktop_file,
    type: 'desktop',
    po_dir: po_dir,
    install: true,
    install_dir: get_option('datadir') / 'applications'
  )
endforeach

foreach appdata_xml: [ 'org.komorebiteam.komorebi.appdata.xml', 'org.komorebiteam.wallpapercreator.appdata.xml' ]
  i18n.merge_file(
    input: 'Other' / appdata_xml + '.in',
    output: appdata_xml,
    po_dir: po_dir,
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
  )
endforeach

install_subdir('Wallpapers', install_dir: get_option('datadir') / meson.project_name(), strip_directory: true)
install_subdir('Fonts', install_dir: get_option('datadir') / 'fonts', strip_directory: true)

# Install only the app icons
install_data('resources/komorebi.svg', 'resources/wallpaper_creator.svg',
  install_dir: get_option('datadir') / 'pixmaps' / meson.project_name()
)
