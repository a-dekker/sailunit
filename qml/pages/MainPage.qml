import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.sailunit.Launcher 1.0
import SortFilterProxyModel 0.2
import "../common"

Page {
    id: mainPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted

    App {
        id: bar
    }

    property string unitName
    property string unitType
    property string unitOwner
    property string unitState

    function loadUnitInfo() {
        var myElement
        var unitString
        var data = bar.launch(
                    "/usr/share/harbour-sailunit/helper/sailunithelper.sh --listunits --units "
                    + mainapp.unit_type + " --owner " + mainapp.current_user)
        data = data.split('\n')
        for (var i = 0; i < data.length - 1; i++) {
            myElement = data[i].split(";")
            unitOwner = myElement[0].trim()
            unitType = myElement[1].trim()
            unitState = myElement[2].trim()
            unitName = myElement[3].trim()
            appendList(unitOwner, unitType, unitState, unitName)
        }
    }

    function appendList(unitOwner, unitType, unitState, unitName) {
        listUnitModel.append({
                                 unitOwner: unitOwner,
                                 unitType: unitType,
                                 unitState: unitState,
                                 unitName: unitName
                             })
    }

    Component.onCompleted: {
        loadUnitInfo()
    }

    SearchPanel {
        id: searchPanel
    }

    Item {
        id: headerBox
        // attach y position of header box to list view content y position
        // that way the header box moves accordingly when pulley menus are opened
        y: 0 - listUnit.contentY - height
        z: 1
        width: parent.width
        height: pageHeader.height

        PageHeaderExtended {
            id: pageHeader
            anchors.top: parent.top
            anchors.left: parent.left
            width: listUnit.width
            title: qsTr("SailUnit" + " (" + current_user + ")")
            subTitle: mainapp.unit_type + qsTr(" unit files")
            subTitleOpacity: 0.5
            subTitleBottomMargin: isPortrait ? Theme.paddingSmall : -30
        }
    }

    SilicaListView {
        id: listUnit

        anchors {
            fill: parent
            bottomMargin: 0
            topMargin: searchPanel.visibleSize
        }
        clip: true

        header: Item {
            id: header
            // This is just a placeholder for the header box. To avoid the
            // list view resetting the input box everytime the model resets,
            // the search entry is defined outside the list view.
            width: pageHeader.width
            height: pageHeader.height
            Component.onCompleted: pageHeader.parent = header
        }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: mainapp.current_user
                      === "all" ? qsTr("Show only system (root)") : mainapp.current_user
                                  == "root" ? qsTr("Show only users (nemo)") : qsTr(
                                                  "Show all users")
                onClicked: {
                    mainapp.current_user
                            === "all" ? mainapp.current_user = "root" : mainapp.current_user
                                        == "root" ? mainapp.current_user
                                                    = "nemo" : mainapp.current_user = "all"
                    listUnitModel.clear()
                    loadUnitInfo()
                }
            }
            MenuItem {
                text: mainapp.unit_type
                      === "all" ? qsTr("Show only services") : mainapp.unit_type
                                  === "service" ? qsTr("Show only sockets") : mainapp.unit_type === "socket" ? qsTr("Show only targets") : mainapp.unit_type === "target" ? qsTr("Show only mounts") : mainapp.unit_type === "mount" ? qsTr("Show only automounts") : mainapp.unit_type === "automount" ? qsTr("Show only timers") : mainapp.unit_type === "timer" ? qsTr("Show only busnames") : mainapp.unit_type === "busname" ? qsTr("Show only slices") : mainapp.unit_type === "slice" ? qsTr("Show only scopes") : qsTr("Show all")
                onClicked: {
                    mainapp.unit_type === "all" ? mainapp.unit_type = "service" : mainapp.unit_type === "service" ? mainapp.unit_type = "socket" : mainapp.unit_type === "socket" ? mainapp.unit_type = "target" : mainapp.unit_type === "target" ? mainapp.unit_type = "mount" : mainapp.unit_type === "mount" ? mainapp.unit_type = "automount" : mainapp.unit_type === "automount" ? mainapp.unit_type = "timer" : mainapp.unit_type === "timer" ? mainapp.unit_type = "busname" : mainapp.unit_type === "busname" ? mainapp.unit_type = "slice" : mainapp.unit_type === "slice" ? mainapp.unit_type = "scope" : mainapp.unit_type = "all"
                    listUnitModel.clear()
                    loadUnitInfo()
                }
            }
            SearchMenuItem {
            }
        }
        VerticalScrollDecorator {
        }

        ListModel {
            id: listUnitModel
        }

        model: listUnitProxyModel

        SortFilterProxyModel {
            id: listUnitProxyModel
            sourceModel: listUnitModel
            filters: RegExpFilter {
                roleName: "unitName"
                pattern: searchPanel.searchText
                caseSensitivity: Qt.CaseInsensitive
            }
            sorters: StringSorter {
                roleName: "unitName"
            }
        }

        ViewPlaceholder {
            id: placeholder
            enabled: listUnit.count === 0
            text: qsTr("No " + current_user + " systemd " + mainapp.unit_type + " units present")
        }
        delegate: ListItem {
            id: listUnitItem
            menu: contextMenu

            function show_content(action) {
                pageStack.push(Qt.resolvedUrl("ContentPage.qml"), {
                                   u_owner: listUnitProxyModel.get(index).unitOwner,
                                   u_type: listUnitProxyModel.get(index).unitType,
                                   u_name: listUnitProxyModel.get(index).unitName,
                                   u_action: action
                               })
            }

            Rectangle {
                id: stateRect
                x: Theme.paddingSmall
                anchors.top: parent.top
                anchors.left: parent.left
                color: (unitState === "disabled" ? "darkred" : (unitState
                                                                === "enabled" ? "green" : "gray"))
                width: Theme.paddingMedium
                height: parent.height
                radius: 10.0
            }

            Label {
                id: unitLabel
                anchors.top: parent.top
                anchors.left: stateRect.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.rightMargin: Theme.paddingSmall
                text: Theme.highlightText(unitName, searchPanel.searchText, Theme.highlightColor) + " [" + unitType + "]"
                textFormat: Text.StyledText
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width - stateRect.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
                color: unitType === "service" ? Theme.highlightColor : unitType
                                                === "service" ? Theme.primaryColor : unitType === "target" ? Theme.secondaryColor : Theme.secondaryHighlightColor
            }
            Label {
                id: unitSubLabel
                anchors.top: unitLabel.bottom
                anchors.left: stateRect.right
                anchors.rightMargin: Theme.paddingSmall
                anchors.leftMargin: Theme.paddingMedium
                text: unitOwner === "nemo" ? "[user/" + unitOwner + "] " + unitState : "[system/"
                                             + unitOwner + "] " + unitState
                width: parent.width
                truncationMode: TruncationMode.Fade
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
            }
            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("Show content")
                        onClicked: {
                            show_content("cat")
                        }
                    }
                    MenuItem {
                        text: qsTr("Show all available properties")
                        onClicked: {
                            show_content("show")
                        }
                    }
                    MenuItem {
                        text: qsTr("Show dependencies")
                        onClicked: {
                            show_content("list-dependencies")
                        }
                    }
                    MenuItem {
                        text: qsTr("Show status")
                        onClicked: {
                            show_content("status")
                        }
                    }
                }
            }
            onClicked: {
                show_content("cat")
            }
        }
    }
}
