import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailunit.Launcher 1.0

Page {
    id: helpPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
    Screen.sizeCategory === Screen.ExtraLarge

    property string u_owner: ""
    property string u_type: ""
    property string u_name: ""
    property string infoText

    App {
        id: bar
    }

    function getFileInfo() {
        var user_cmd
        if ( u_owner === "nemo" ) {
            user_cmd = "--user "
        } else {
            user_cmd = ""
        }
        infoText = bar.launch("/bin/systemctl " + user_cmd + "cat " + u_name + '.' + u_type)
        infoText = infoText.replace(/\[/g,'<b>[').replace(/\]/g,']</b>')
        infoText = infoText.replace(/\n/gm, "<br>")
    }

    Component.onCompleted: {
        getFileInfo()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {}

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr(u_name + '.' + u_type)
            }
            Label {
                text: infoText
                font.pixelSize: largeScreen ? Theme.fontSizeSmall : Theme.fontSizeExtraSmall
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
            }
        }
    }
}
