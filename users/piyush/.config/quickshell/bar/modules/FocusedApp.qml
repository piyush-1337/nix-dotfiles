import QtQuick
import Quickshell.Hyprland
import "../widgets"
import "../theme"

Item {
    id: root

    property int maxWidth: 420

    readonly property var activeToplevel: Hyprland.activeToplevel
    readonly property var activeWayland: activeToplevel ? activeToplevel.wayland : null
    readonly property string appName: Theme.formatAppId(activeWayland ? activeWayland.appId : "")
    readonly property string titleText: Theme.trimTitle(activeToplevel ? activeToplevel.title : "", appName)
    readonly property bool hasContent: (appName && appName.length > 0) || (titleText && titleText.length > 0)

    visible: hasContent
    readonly property int iconBoxWidth: 18
    readonly property int rowSpacing: Theme.spacingS
    readonly property int separatorWidth: (appName.length && titleText.length) ? 3 : 0
    readonly property int chromeWidth: iconBoxWidth + rowSpacing + (appName.length ? Math.min(appText.implicitWidth, 120) : 0) + (separatorWidth ? (rowSpacing + separatorWidth) : 0)
    readonly property int titleAvailableWidth: Math.max(90, maxWidth - surface.leftPadding - surface.rightPadding - chromeWidth - (titleText.length ? rowSpacing : 0))

    implicitHeight: Theme.clusterHeight
    width: visible ? Math.min(surface.leftPadding + surface.rightPadding + contentRow.implicitWidth, maxWidth) : 0
    height: Theme.clusterHeight

    Surface {
        id: surface

        anchors.fill: parent
        leftPadding: 10
        rightPadding: 12
        startColor: Theme.withAlpha(Theme.colors.surfaceContainerHigh, 0.98)
        endColor: Theme.withAlpha(Theme.colors.surfaceContainer, 0.95)
        borderColor: Theme.withAlpha(Theme.colors.outline, 0.22)

        Row {
            id: contentRow

            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacingS

            Rectangle {
                width: 18
                height: 18
                radius: 6
                color: Theme.withAlpha(Theme.colors.primary, 0.16)
                border.width: 1
                border.color: Theme.withAlpha(Theme.colors.primary, 0.26)

                Text {
                    anchors.centerIn: parent
                    text: root.appName.length ? root.appName.charAt(0).toUpperCase() : "?"
                    color: Theme.colors.primary
                    font.family: Theme.fontFamily
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                }
            }

            Text {
                id: appText

                text: root.appName
                visible: text.length > 0
                elide: Text.ElideRight
                maximumLineCount: 1
                width: Math.min(implicitWidth, 120)
                color: Theme.withAlpha(Theme.colors.onSurfaceVariant, 0.95)
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                visible: appText.visible && titleTextItem.visible
                width: 3
                height: 3
                radius: 2
                color: Theme.withAlpha(Theme.colors.onSurfaceVariant, 0.5)
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: titleTextItem

                text: root.titleText.length ? root.titleText : root.appName
                visible: text.length > 0
                elide: Text.ElideRight
                maximumLineCount: 1
                width: Math.min(implicitWidth, root.titleAvailableWidth)
                color: Theme.colors.onSurface
                font.family: Theme.fontFamily
                font.pixelSize: 12
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
