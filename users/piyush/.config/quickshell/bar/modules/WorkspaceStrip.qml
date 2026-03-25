import QtQuick
import Quickshell.Hyprland
import "../widgets"
import "../theme"

Item {
    id: root

    required property var screen

    readonly property int workspaceCount: Theme.workspaceCount
    readonly property var boundMonitor: screen ? Hyprland.monitorFor(screen) : null
    readonly property string monitorName: boundMonitor ? boundMonitor.name : ""
    readonly property int activeWorkspaceId: boundMonitor && boundMonitor.activeWorkspace ? boundMonitor.activeWorkspace.id : (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1)

    implicitHeight: Theme.clusterHeight
    implicitWidth: 6 + 6 + workspaceRow.implicitWidth

    function workspaceFor(id) {
        var list = Hyprland.workspaces ? Hyprland.workspaces.values : [];
        for (var i = 0; i < list.length; ++i) {
            var workspace = list[i];
            if (!workspace || workspace.id !== id || workspace.id < 1)
                continue;
            if (!monitorName || !workspace.monitor || workspace.monitor.name === monitorName)
                return workspace;
        }
        return null;
    }

    function isOccupied(id) {
        var toplevels = Hyprland.toplevels ? Hyprland.toplevels.values : [];
        for (var i = 0; i < toplevels.length; ++i) {
            var toplevel = toplevels[i];
            if (!toplevel || !toplevel.workspace || toplevel.workspace.id !== id)
                continue;
            if (!monitorName || !toplevel.monitor || toplevel.monitor.name === monitorName)
                return true;
        }
        return false;
    }

    width: implicitWidth
    height: surface.implicitHeight

    Surface {
        id: surface

        anchors.fill: parent
        leftPadding: 6
        rightPadding: 6
        startColor: Theme.withAlpha(Theme.colors.surfaceContainerHigh, 0.985)
        endColor: Theme.withAlpha(Theme.colors.surfaceContainer, 0.95)
        borderColor: Theme.withAlpha(Theme.colors.outline, 0.22)

        Row {
            id: workspaceRow
            anchors.centerIn: parent
            spacing: 2

            Repeater {
                model: root.workspaceCount

                delegate: Item {
                    id: cell

                    readonly property int workspaceId: index + 1
                    readonly property bool active: workspaceId === root.activeWorkspaceId
                    readonly property bool existing: root.workspaceFor(workspaceId) !== null
                    readonly property bool occupied: root.isOccupied(workspaceId)

                    width: 28
                    height: 24

                    Rectangle {
                        anchors.fill: parent
                        radius: 9
                        color: cell.active ? Theme.withAlpha(Theme.colors.primary, 0.9) : (cellMouse.containsMouse ? Theme.withAlpha(Theme.colors.onSurface, 0.08) : "transparent")
                        border.width: cell.active ? 0 : ((cell.existing || cell.occupied) ? 1 : 0)
                        border.color: Theme.withAlpha(Theme.colors.outline, 0.16)

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: String(cell.workspaceId)
                        color: cell.active ? Theme.colors.onPrimary : ((cell.existing || cell.occupied) ? Theme.colors.onSurface : Theme.withAlpha(Theme.colors.onSurfaceVariant, 0.55))
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.weight: cell.active ? Font.DemiBold : Font.Medium
                    }

                    Rectangle {
                        visible: !cell.active && cell.occupied
                        width: 4
                        height: 4
                        radius: 2
                        color: Theme.colors.primary
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                    }

                    MouseArea {
                        id: cellMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Hyprland.dispatch("workspace " + cell.workspaceId)
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton

            onWheel: function(wheel) {
                if (wheel.angleDelta.y > 0) {
                    Hyprland.dispatch("workspace e-1");
                } else if (wheel.angleDelta.y < 0) {
                    Hyprland.dispatch("workspace e+1");
                }
                wheel.accepted = true;
            }
        }
    }
}
