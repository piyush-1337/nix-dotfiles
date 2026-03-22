import QtQuick
import Quickshell.Services.SystemTray
import "../theme"

Item {
    id: root

    required property SystemTrayItem trayItem
    required property var barWindow

    implicitWidth: 24
    implicitHeight: 24

    function menuPosition() {
        if (barWindow && barWindow.contentItem)
            return root.mapToItem(barWindow.contentItem, root.width / 2, root.height);
        return root.mapToItem(null, root.width / 2, root.height);
    }

    function openMenu() {
        if (!trayItem || !trayItem.hasMenu)
            return;

        var point = menuPosition();
        trayItem.display(barWindow, point.x, point.y);
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: mouseArea.containsMouse ? Theme.withAlpha(Theme.colors.onSurface, 0.08) : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    Image {
        anchors.centerIn: parent
        width: 18
        height: 18
        source: trayItem ? trayItem.icon : ""
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            if (!trayItem)
                return;

            if (mouse.button === Qt.RightButton) {
                root.openMenu();
                return;
            }

            if (trayItem.onlyMenu && trayItem.hasMenu) {
                root.openMenu();
            } else {
                trayItem.activate();
            }
        }

        onWheel: function(wheel) {
            if (!trayItem)
                return;

            trayItem.scroll(wheel.angleDelta.y, false);
            wheel.accepted = true;
        }
    }
}
