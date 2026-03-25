import QtQuick
import Quickshell
import Quickshell.Wayland
import "./theme"

PanelWindow {
    id: root

    color: "transparent"
    surfaceFormat.opaque: false

    anchors {
        left: true
        top: true
        right: true
    }

    margins {
        left: Theme.shellMargin
        top: Theme.shellMargin
        right: Theme.shellMargin
    }

    aboveWindows: true
    focusable: false
    exclusionMode: ExclusionMode.Auto
    implicitHeight: Theme.shellHeight

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:dmsbar"

    BarContent {
        anchors.fill: parent
        barWindow: root
    }
}
