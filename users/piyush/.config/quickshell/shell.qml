import QtQuick
import Quickshell
import "./bar"
import "./bar/theme"

ShellRoot {
    Variants {
        model: Theme.ready ? Quickshell.screens : []

        delegate: BarWindow {
            required property var modelData

            screen: modelData
        }
    }
}
