project (komorebi)
cmake_minimum_required (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/komorebi")
set (RELEASE_NAME "summit")
set (VERSION "2.1")
set (VERSION_INFO "Release")
set (ARCHIVE_NAME komorebi-${VERSION})


find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED gtk+-3.0 glib-2.0>=2.38 gee-0.8 webkit2gtk-4.0 clutter-gtk-1.0 clutter-1.0 clutter-gst-3.0)
add_definitions(${DEPS_CFLAGS})

link_directories(${DEPS_LIBRARY_DIRS})
find_package(Vala REQUIRED)
include(ValaVersion)
include(ValaPrecompile)


find_package(Vala REQUIRED)


ensure_vala_version("0.16" MINIMUM)
vala_precompile(VALA_C
    src/Main.vala

    src/OnScreen/BackgroundWindow.vala
    src/OnScreen/DateTimeBox.vala
    src/OnScreen/DesktopIcons.vala
    src/OnScreen/ResponsiveGrid.vala
    src/OnScreen/Icon.vala
    src/OnScreen/InfoWindow.vala
    src/OnScreen/RowLabel.vala
    src/OnScreen/WallpapersSelector.vala
    src/OnScreen/Thumbnail.vala
    src/OnScreen/BubbleMenu.vala
    src/OnScreen/BubbleMenuItem.vala
    src/OnScreen/AssetActor.vala
    src/OnScreen/PreferencesWindow.vala

    src/Utilities.vala


PACKAGES
    gtk+-3.0
    gee-0.8
    clutter-gtk-1.0
    clutter-gst-3.0
    webkit2gtk-4.0
OPTIONS
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
   	--disable-warnings

)
vala_precompile(WALLPAPER_CREATOR
    extra/wallpaper-creator/Main.vala

    extra/wallpaper-creator/OnScreen/NewWallpaperWindow.vala
    extra/wallpaper-creator/OnScreen/InitialPage.vala
    extra/wallpaper-creator/OnScreen/OptionsPage.vala
    extra/wallpaper-creator/OnScreen/FinalPage.vala


PACKAGES
    gee-0.8
    gtk+-3.0
    gstreamer-1.0
    webkit2gtk-4.0
OPTIONS
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
    --disable-warnings

)

add_definitions(${CFLAGS} -Wall -Winit-self -Wwrite-strings -Wunreachable-code -Wstrict-prototypes)
add_executable(komorebi ${VALA_C})
add_executable(komorebi-wallpaper-creator ${WALLPAPER_CREATOR})
target_link_libraries(komorebi ${DEPS_LIBRARIES} -lm)
target_link_libraries(komorebi-wallpaper-creator ${DEPS_LIBRARIES} -lm)

install(TARGETS komorebi RUNTIME DESTINATION /System/Applications/)
install(TARGETS komorebi-wallpaper-creator RUNTIME DESTINATION /System/Applications/)


######### Wallpapers ############
install(DIRECTORY data/Wallpapers/ DESTINATION /System/Resources/Komorebi)


######### Fonts ############
install(DIRECTORY data/Fonts/ DESTINATION /usr/share/fonts)

######### Icons ############
install(DIRECTORY data/Icons/ DESTINATION /System/Resources/Komorebi)

######### Other ############
install(FILES data/Other/komorebi.desktop DESTINATION /usr/share/applications/)
install(FILES data/Other/wallpapercreator.desktop DESTINATION /usr/share/applications/)

######### Run the upgrade script #########
install(CODE "execute_process(COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/data/Other/postinst.sh)")

# Packaging configuration
set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Komorebi - An awesome desktop manager for Linux")
set(CPACK_PACKAGE_VENDOR "")
set(CPACK_PACKAGE_CONTACT "Abraham Masri @cheesecakeufo")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_ICON screenshots/komorebi-icon.png)
set(CPACK_PACKAGE_VERSION_MAJOR 2)
set(CPACK_PACKAGE_VERSION_MINOR 1)
set(CPACK_PACKAGE_VERSION_PATCH 0)
set(CPACK_PACKAGE_INSTALL_DIRECTORY "Komorebi")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/data/Other/postinst;${CMAKE_CURRENT_SOURCE_DIR}/data/Other/postrm;")

set(CPACK_DEBIAN_PACKAGE_DEPENDS "libgtk-3-0 (>= 3.14), libglib2.0-0 (>= 2.38), libgee-0.8-2, libclutter-gtk-1.0-0, libclutter-1.0-0, libclutter-gst-3.0-0, libwebkit2gtk-4.0-37")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
set(CPACK_DEBIAN_PACKAGE_SECTION "system")

include(CPack)
