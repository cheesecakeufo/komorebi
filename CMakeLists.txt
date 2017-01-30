project (komorebi)
cmake_minimum_required (VERSION 2.8)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/komorebi")
set (RELEASE_NAME "summit")
set (VERSION "0.1")
set (VERSION_INFO "Stable")
set (ARCHIVE_NAME komorebi-${VERSION})


find_package(PkgConfig)
add_definitions(${DEPS_CFLAGS})


link_directories(${DEPS_LIBRARY_DIRS})
find_package(Vala REQUIRED)
include(ValaVersion)
include(ValaPrecompile)

pkg_check_modules(DEPS REQUIRED acis gtk+-3.0)
find_package(Vala REQUIRED)

ensure_vala_version("0.16" MINIMUM)
vala_precompile(VALA_C
    src/Main.vala

    src/OnScreen/BackgroundWindow.vala
    
PACKAGES
	acis
    gtk+-3.0
    gio-2.0
OPTIONS
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
   --disable-warnings
    )

add_definitions(${CFLAGS} -Wall -Winit-self -Wwrite-strings -Wunreachable-code -Wstrict-prototypes)
add_executable(komorebi ${VALA_C})
target_link_libraries(komorebi ${DEPS_LIBRARIES})

install(TARGETS komorebi RUNTIME DESTINATION /System/Applications/)


######### Wallpapers ############
install(DIRECTORY data/Wallpapers/cloudy_forest/ DESTINATION /System/Resources/Komorebi/cloudy_forest)
install(DIRECTORY data/Wallpapers/dark_forest/ DESTINATION /System/Resources/Komorebi/dark_forest)

