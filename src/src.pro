TEMPLATE = app

TARGET = harbour-sailunit
CONFIG += sailfishapp

#QT += declarative

SOURCES += sailunit.cpp \
    settings.cpp \
    osread.cpp

HEADERS += \
    settings.h \
    osread.h

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}

OTHER_FILES +=

