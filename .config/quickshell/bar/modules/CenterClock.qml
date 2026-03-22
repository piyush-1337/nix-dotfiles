import QtQuick
import Quickshell
import "../widgets"
import "../theme"

Item {
    id: root

    implicitHeight: Theme.clusterHeight
    implicitWidth: 14 + 14 + clockRow.implicitWidth
    width: implicitWidth
    height: surface.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Surface {
        id: surface

        anchors.fill: parent
        leftPadding: 14
        rightPadding: 14
        startColor: Theme.withAlpha(Theme.colors.surfaceContainerHighest, 0.985)
        endColor: Theme.withAlpha(Theme.colors.surfaceContainerHigh, 0.95)
        borderColor: Theme.withAlpha(Theme.colors.outline, 0.26)

        Row {
            id: clockRow
            anchors.centerIn: parent
            spacing: Theme.spacingS

            Text {
                text: Qt.formatDateTime(clock.date, "ddd d MMM")
                color: Theme.withAlpha(Theme.colors.onSurfaceVariant, 0.92)
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Font.Medium
            }

            Rectangle {
                width: 3
                height: 3
                radius: 2
                color: Theme.withAlpha(Theme.colors.primary, 0.95)
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: Qt.formatDateTime(clock.date, "HH:mm")
                color: Theme.colors.onSurface
                font.family: Theme.fontFamily
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }
        }
    }
}
