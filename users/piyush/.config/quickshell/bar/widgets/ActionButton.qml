import QtQuick
import "."
import "../theme"

Item {
    id: root

    property alias iconSource: icon.source
    property real iconSize: 18
    property bool accent: false

    signal clicked

    implicitWidth: Theme.clusterHeight
    implicitHeight: Theme.clusterHeight

    Surface {
        anchors.fill: parent
        hovered: mouseArea.containsMouse
        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0
        startColor: root.accent ? Theme.mix(Theme.colors.surfaceContainerHigh, Theme.colors.primary, 0.16) : Theme.withAlpha(Theme.colors.surfaceContainerHigh, 0.98)
        endColor: root.accent ? Theme.mix(Theme.colors.surfaceContainer, Theme.colors.primary, 0.09) : Theme.withAlpha(Theme.colors.surfaceContainer, 0.95)
        borderColor: root.accent ? Theme.withAlpha(Theme.colors.primary, 0.34) : Theme.withAlpha(Theme.colors.outline, 0.24)
        hoverColor: root.accent ? Theme.withAlpha(Theme.colors.primary, 0.12) : Theme.withAlpha(Theme.colors.primary, 0.06)

        Image {
            id: icon

            anchors.centerIn: parent
            width: root.iconSize
            height: root.iconSize
            smooth: true
            mipmap: true
            fillMode: Image.PreserveAspectFit
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
