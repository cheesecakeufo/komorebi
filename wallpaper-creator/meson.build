sources = files(
    'Main.vala',
    'OnScreen/NewWallpaperWindow.vala',
    'OnScreen/InitialPage.vala',
    'OnScreen/OptionsPage.vala',
    'OnScreen/FinalPage.vala'
)

executable(meson.project_name() + '-wallpaper-creator', sources, komorebiconfiguration, komorebiresources,
    dependencies: dependencies,
    install: true
)
