import QtQuick
import "../theme"

Item {
    id: root

    default property alias contentData: content.data

    property bool hovered: false
    property real radius: Theme.clusterRadius
    property real preferredHeight: Theme.clusterHeight
    property real leftPadding: 10
    property real rightPadding: 10
    property real topPadding: 0
    property real bottomPadding: 0

    property color startColor: Theme.withAlpha(Theme.colors.surfaceContainerHigh, 0.97)
    property color endColor: Theme.withAlpha(Theme.colors.surfaceContainer, 0.95)
    property color borderColor: Theme.withAlpha(Theme.colors.outline, 0.24)
    property color hoverColor: Theme.withAlpha(Theme.colors.primary, 0.08)

    implicitWidth: 0
    implicitHeight: preferredHeight

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: Theme.withAlpha("#000000", 0.12)
        y: 1
        z: -1
    }

    Rectangle {
        id: background

        anchors.fill: parent
        radius: root.radius
        border.width: 1
        border.color: root.borderColor
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: root.startColor
            }
            GradientStop {
                position: 1.0
                color: root.endColor
            }
        }
    }

    Rectangle {
        anchors.fill: background
        radius: root.radius
        color: root.hoverColor
        opacity: root.hovered ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }
    }

    Rectangle {
        anchors.left: background.left
        anchors.top: background.top
        anchors.right: background.right
        height: Math.round(background.height * 0.48)
        radius: root.radius
        color: Theme.withAlpha(Theme.colors.onSurface, 0.01)
    }

    Item {
        id: content

        anchors.fill: parent
        anchors.leftMargin: root.leftPadding
        anchors.rightMargin: root.rightPadding
        anchors.topMargin: root.topPadding
        anchors.bottomMargin: root.bottomPadding
    }
}
