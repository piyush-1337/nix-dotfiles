import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import "../widgets"
import "../theme"

Item {
    id: root

    required property var barWindow

    PwObjectTracker {
        objects: Pipewire.nodes ? Pipewire.nodes.values.filter(node => node && node.audio && !node.isStream) : []
    }

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool sinkReady: !!(sink && sink.ready && sink.audio)
    readonly property var sinkAudio: sinkReady ? sink.audio : null
    readonly property int volumePercent: (sink && sink.ready && sink.audio) ? Math.round(Theme.clamp(sink.audio.volume * 100, 0, 150)) : 0
    readonly property bool volumeMuted: (sink && sink.ready && sink.audio) ? (sink.audio.muted || sink.audio.volume <= 0) : false
    readonly property string volumeIconName: Theme.volumeIcon(volumePercent, volumeMuted)
    readonly property var trayItems: {
        var source = SystemTray.items ? SystemTray.items.values : [];
        var values = [];
        for (var i = 0; i < source.length; ++i)
            values.push(source[i]);
        return values;
    }

    readonly property var laptopBattery: {
        var devices = UPower.devices ? UPower.devices.values : [];
        for (var i = 0; i < devices.length; ++i) {
            var device = devices[i];
            if (device && device.ready && device.isLaptopBattery && device.isPresent)
                return device;
        }

        if (UPower.displayDevice && UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery)
            return UPower.displayDevice;

        return null;
    }

    readonly property bool hasBattery: laptopBattery !== null
    readonly property real batteryPercent: hasBattery ? Theme.normalizedPercent(laptopBattery.percentage) : 0
    readonly property bool batteryCharging: hasBattery ? (laptopBattery.timeToFull > 0 || laptopBattery.changeRate > 0) : false

    implicitHeight: Theme.clusterHeight
    implicitWidth: 8 + 8 + statusRow.implicitWidth
    width: implicitWidth
    height: surface.implicitHeight

    function setVolume(percent) {
        if (!sinkReady)
            return;

        sinkAudio.muted = false;
        sinkAudio.volume = Theme.clamp(percent, 0, 150) / 100;
    }

    function changeVolume(delta) {
        setVolume(volumePercent + delta);
    }

    function toggleMute() {
        if (!sinkReady)
            return;

        sinkAudio.muted = !sinkAudio.muted;
    }

    function lockSession() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
    }

    Surface {
        id: surface

        anchors.fill: parent
        leftPadding: 8
        rightPadding: 8
        startColor: Theme.withAlpha(Theme.colors.surfaceContainerHigh, 0.985)
        endColor: Theme.withAlpha(Theme.colors.surfaceContainer, 0.95)
        borderColor: Theme.withAlpha(Theme.colors.outline, 0.24)

        Row {
            id: statusRow
            anchors.centerIn: parent
            spacing: Theme.spacingS

            Item {
                id: trayArea

                visible: root.trayItems.length > 0
                width: trayRow.implicitWidth
                height: Theme.clusterHeight

                Row {
                    id: trayRow

                    anchors.centerIn: parent
                    spacing: 2

                    Repeater {
                        model: root.trayItems

                        delegate: TrayItemButton {
                            required property var modelData
                            trayItem: modelData
                            barWindow: root.barWindow
                        }
                    }
                }
            }

            Rectangle {
                visible: trayArea.visible
                width: 1
                height: 14
                radius: 1
                color: Theme.withAlpha(Theme.colors.outline, 0.18)
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: volumeArea

                width: volumeRow.implicitWidth + 12
                height: Theme.clusterHeight

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: volumeMouse.containsMouse ? Theme.withAlpha(Theme.colors.onSurface, 0.06) : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                Row {
                    id: volumeRow

                    anchors.centerIn: parent
                    spacing: 6

                    Image {
                        width: 16
                        height: 16
                        source: Qt.resolvedUrl("../assets/volume-" + root.volumeIconName + ".svg")
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                        mipmap: true
                    }

                    Text {
                        text: root.sinkReady ? root.volumePercent + "%" : "--"
                        color: Theme.colors.onSurface
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Medium
                    }
                }

                MouseArea {
                    id: volumeMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.toggleMute()
                    onWheel: function(wheel) {
                        if (wheel.angleDelta.y > 0) {
                            root.changeVolume(5);
                        } else if (wheel.angleDelta.y < 0) {
                            root.changeVolume(-5);
                        }
                        wheel.accepted = true;
                    }
                }
            }

            Rectangle {
                visible: root.hasBattery
                width: 1
                height: 14
                radius: 1
                color: Theme.withAlpha(Theme.colors.outline, 0.18)
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: batteryArea

                visible: root.hasBattery
                width: batteryRow.implicitWidth + 12
                height: Theme.clusterHeight

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: batteryMouse.containsMouse ? Theme.withAlpha(Theme.colors.onSurface, 0.05) : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                RowLayout {
                    id: batteryRow

                    anchors.centerIn: parent
                    spacing: 6

                    BatteryGlyph {
                        Layout.alignment: Qt.AlignVCenter
                        percent: root.batteryPercent
                        charging: root.batteryCharging
                    }

                    Text {
                        id: batteryText
                        Layout.alignment: Qt.AlignVCenter
                        text: Math.round(root.batteryPercent) + "%"
                        color: Theme.colors.onSurface
                        font.family: Theme.fontFamily
                        font.pixelSize: 12
                        font.weight: Font.Medium
                    }
                }

                MouseArea {
                    id: batteryMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                }
            }

            Rectangle {
                width: 1
                height: 14
                radius: 1
                color: Theme.withAlpha(Theme.colors.outline, 0.18)
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                id: lockArea

                width: 28
                height: Theme.clusterHeight

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: lockMouse.containsMouse ? Theme.withAlpha(Theme.colors.primary, 0.08) : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                Image {
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    source: Qt.resolvedUrl("../assets/lock.svg")
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    mipmap: true
                }

                MouseArea {
                    id: lockMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.lockSession()
                }
            }
        }
    }
}
