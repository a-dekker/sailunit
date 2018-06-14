import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailunit.Launcher 1.0
import "../common"

Page {
    id: helpPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
    Screen.sizeCategory === Screen.ExtraLarge

    property string u_owner: ""
    property string u_type: ""
    property string u_name: ""
    property string u_action: ""
    property string infoText

    App {
        id: bar
    }

    function getFileInfo() {
        var user_cmd
        var user_act
        if ( u_owner === "nemo" ) {
            user_cmd = "--user "
        } else {
            user_cmd = ""
        }
        if ( u_action === "show") {
            user_act = "show --all"
        } else {
            user_act = u_action
        }
        infoText = bar.launch("/bin/systemctl " + user_cmd + user_act + " -- " + u_name + '.' + u_type)
        if (u_action === "cat") {
            infoText = infoText.replace(/\[/g,'<b>[').replace(/\]/g,']</b>')
        } else {
            var re = /^(\w+)=/gm;
            infoText = infoText.replace(re, '<b>$1</b>=')
        }
        infoText = infoText.replace(/\n/gm, '<br>')
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

            PageHeaderExtended {
                id: pageHeader
                title: qsTr(u_name + '.' + u_type)
                subTitle: u_action === "cat" ? qsTr("content") : u_action === "list-dependencies" ? qsTr("dependencies") : qsTr("all properties")
                subTitleOpacity: 0.5
                subTitleBottomMargin: isPortrait ? Theme.paddingSmall : -30
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
