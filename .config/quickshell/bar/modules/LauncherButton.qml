import QtQuick
import Quickshell
import "../widgets"

ActionButton {
    id: root

    accent: true
    iconSource: Qt.resolvedUrl("../assets/hyprland.svg")
    iconSize: 20

    onClicked: {
        Quickshell.execDetached([
            "sh",
            "-lc",
            "if command -v hyprlauncher >/dev/null 2>&1; then exec hyprlauncher; fi; if command -v fuzzel >/dev/null 2>&1; then exec fuzzel; fi; if command -v wofi >/dev/null 2>&1; then exec wofi --show drun; fi; if command -v rofi >/dev/null 2>&1; then exec rofi -show drun; fi; if command -v kitty >/dev/null 2>&1; then exec kitty; fi"
        ]);
    }
}
