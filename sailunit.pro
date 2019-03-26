# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop on filename must be changed
#   -  filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-sailunit

DEPLOYMENT_PATH = /usr/share/$${TARGET}

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}

CONFIG += sailfishapp
CONFIG += c++11

OTHER_FILES += qml/sailunit.qml \
    qml/cover/CoverPage.qml \
    rpm/sailunit.changes.in \
    rpm/sailunit.spec \
    translations/*.ts \
    harbour-sailunit.desktop \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/ContentPage.qml \
    qml/common/PageHeaderExtended.qml \
    qml/common/SearchMenuItem.qml \
    qml/common/SearchPanel.qml \
    helper/sailunithelper.sh \
    rpm/sailunit.spec

INSTALLS += translations

TRANSLATIONS = translations/harbour-sailunit-nl.ts \

SOURCES += src/sailunit.cpp \
    src/settings.cpp \
    src/osread.cpp

HEADERS += \
    src/settings.h \
    src/osread.h

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}

script.files = helper/*
script.path = /usr/share/harbour-sailunit/helper

icon86.files += icons/86x86/harbour-sailunit.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-sailunit.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-sailunit.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon172.files += icons/172x172/harbour-sailunit.png
icon172.path = /usr/share/icons/hicolor/172x172/apps

icon256.files += icons/256x256/harbour-sailunit.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

INSTALLS += icon86 icon108 icon128 icon172 icon256 script

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
include(SortFilterProxyModel/SortFilterProxyModel.pri)
