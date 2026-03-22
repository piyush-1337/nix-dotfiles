import QtQuick
import "../theme"

Item {
    id: root

    property real percent: 100
    property bool charging: false

    readonly property real clampedPercent: Theme.clamp(percent, 0, 100)
    readonly property color glyphColor: Theme.batteryColor(clampedPercent, charging)

    implicitWidth: 17
    implicitHeight: 10

    Rectangle {
        x: 0
        y: 1
        width: 15
        height: 8
        radius: 2
        color: "transparent"
        border.width: 1
        border.color: Theme.withAlpha(root.glyphColor, 0.78)
    }

    Rectangle {
        x: 15
        y: 3
        width: 2
        height: 4
        radius: 1
        color: Theme.withAlpha(root.glyphColor, 0.78)
    }

    Rectangle {
        x: 2
        y: 3
        width: Math.max(2, Math.round(11 * (root.clampedPercent / 100)))
        height: 4
        radius: 1
        color: root.glyphColor
    }

    Text {
        anchors.centerIn: parent
        text: "+"
        visible: root.charging
        color: Theme.withAlpha(Theme.colors.primary, 0.96)
        font.family: Theme.fontFamily
        font.pixelSize: 7
        font.weight: Font.DemiBold
    }
}
