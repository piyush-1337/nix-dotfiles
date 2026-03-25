import QtQuick
import "./modules"
import "./widgets"
import "./theme"

Item {
    id: root

    required property var barWindow

    BarShell {
        anchors.fill: parent

        Item {
            id: contentArea

            anchors.fill: parent
            anchors.margins: Theme.shellPadding

            readonly property real sideBudget: Math.max(320, (width - centerClock.width - Theme.spacingL * 2) / 2)

            Item {
                id: leftSection

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: leftRow.width
                height: Theme.clusterHeight

                Row {
                    id: leftRow

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.spacingS

                    LauncherButton {
                        id: launcherButton
                    }

                    WorkspaceStrip {
                        id: workspaceStrip
                        screen: root.barWindow.screen
                    }

                    FocusedApp {
                        id: focusedApp
                        maxWidth: Math.max(160, contentArea.sideBudget - launcherButton.width - workspaceStrip.width - Theme.spacingS * 2)
                    }
                }
            }

            CenterClock {
                id: centerClock
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            StatusCluster {
                id: rightCluster
                barWindow: root.barWindow
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
