pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property real shellMargin: 4
    readonly property real shellHeight: 48
    readonly property real shellRadius: 18
    readonly property real shellPadding: 4

    readonly property real clusterHeight: 36
    readonly property real clusterRadius: 13

    readonly property real spacingXS: 4
    readonly property real spacingS: 8
    readonly property real spacingM: 12
    readonly property real spacingL: 16

    readonly property string fontFamily: "GeistMono Nerd Font"
    readonly property int workspaceCount: 10

    readonly property string homeDir: Quickshell.env("HOME") || ""
    readonly property string wallpaperConfigPath: homeDir + "/.config/hypr/hyprpaper.conf"
    readonly property string matugenMode: "dark"
    readonly property int matugenSourceColorIndex: 0

    readonly property var fallbackColors: ({
        background: "#101417",
        surfaceLow: "#181c20",
        surfaceContainer: "#1c2024",
        surfaceContainerHigh: "#262a2e",
        surfaceContainerHighest: "#313539",
        surfaceLowest: "#0a0f12",
        primary: "#93cdf6",
        onPrimary: "#00344c",
        onSurface: "#dfe3e7",
        onSurfaceVariant: "#c1c7ce",
        outline: "#8b9198",
        error: "#ffb4ab"
    })

    property var colors: fallbackColors
    property bool ready: false
    property string loadError: ""
    property string wallpaperPath: ""
    property string _matugenStdout: ""
    property string _matugenStderr: ""

    signal themeChanged()

    Component.onCompleted: refresh()

    function refresh() {
        ready = false;
        loadError = "";
        wallpaperPath = "";
        _matugenStdout = "";
        _matugenStderr = "";
        timeoutTimer.restart();
        const configText = wallpaperConfigFile.text();
        const parsedWallpaper = _extractWallpaperPath(configText);

        if (!parsedWallpaper) {
            _applyFallback("Could not find a wallpaper path in " + wallpaperConfigPath + ".");
            return;
        }

        _startMatugen(parsedWallpaper);
    }

    function cloneObject(source) {
        return JSON.parse(JSON.stringify(source));
    }

    function clamp(value, min, max) {
        return Math.max(min, Math.min(max, value));
    }

    function _rgbComponent(value, start) {
        return parseInt(value.slice(start, start + 2), 16) / 255;
    }

    function _colorObjectToHex(value) {
        const red = Math.round(clamp(value.r, 0, 1) * 255).toString(16).padStart(2, "0");
        const green = Math.round(clamp(value.g, 0, 1) * 255).toString(16).padStart(2, "0");
        const blue = Math.round(clamp(value.b, 0, 1) * 255).toString(16).padStart(2, "0");
        return "#" + red + green + blue;
    }

    function _normalizeHex(value) {
        if (value === undefined || value === null)
            return "000000";

        if (typeof value === "object" && value.r !== undefined && value.g !== undefined && value.b !== undefined)
            value = _colorObjectToHex(value);

        value = String(value).trim().replace("#", "");
        if (value.length === 8)
            value = value.slice(2);
        if (value.length !== 6)
            return "000000";
        return value;
    }

    function rgba(value, alpha) {
        const normalized = _normalizeHex(value);
        return Qt.rgba(_rgbComponent(normalized, 0), _rgbComponent(normalized, 2), _rgbComponent(normalized, 4), alpha);
    }

    function withAlpha(value, alpha) {
        return rgba(value, alpha);
    }

    function mix(first, second, amount) {
        const left = _normalizeHex(first);
        const right = _normalizeHex(second);
        const ratio = clamp(amount, 0, 1);
        const red = _rgbComponent(left, 0) + (_rgbComponent(right, 0) - _rgbComponent(left, 0)) * ratio;
        const green = _rgbComponent(left, 2) + (_rgbComponent(right, 2) - _rgbComponent(left, 2)) * ratio;
        const blue = _rgbComponent(left, 4) + (_rgbComponent(right, 4) - _rgbComponent(left, 4)) * ratio;
        return Qt.rgba(red, green, blue, 1);
    }

    function normalizedPercent(value) {
        if (value === undefined || value === null)
            return 0;

        let numeric = Number(value);
        if (!isFinite(numeric))
            return 0;

        if (numeric <= 1.0)
            numeric *= 100;

        return clamp(numeric, 0, 100);
    }

    function volumeIcon(volumePercent, muted) {
        if (muted || volumePercent <= 0)
            return "muted";
        if (volumePercent < 35)
            return "low";
        return "high";
    }

    function batteryColor(percent, charging) {
        if (charging)
            return colors.primary;
        if (percent <= 15)
            return colors.error;
        return colors.onSurface;
    }

    function formatAppId(appId) {
        if (!appId)
            return "";

        let cleaned = String(appId);
        const slash = cleaned.lastIndexOf("/");
        if (slash >= 0)
            cleaned = cleaned.slice(slash + 1);

        const dot = cleaned.lastIndexOf(".");
        if (dot >= 0)
            cleaned = cleaned.slice(dot + 1);

        cleaned = cleaned.replace(/[-_]+/g, " ");
        if (!cleaned.length)
            return "";

        return cleaned.charAt(0).toUpperCase() + cleaned.slice(1);
    }

    function trimTitle(title, appName) {
        const value = String(title || "");
        const app = String(appName || "");

        if (!value.length)
            return "";

        if (app.length && value === app)
            return "";

        if (app.length && value.slice(-app.length) === app) {
            let shortened = value.slice(0, value.length - app.length);
            shortened = shortened.replace(/\s*[-|:]\s*$/, "");
            shortened = shortened.trim();
            if (shortened.length)
                return shortened;
        }

        return value;
    }

    function _logFailure(message) {
        loadError = message;
        console.warn("Theme:", message);
    }

    function _finalize(colorsObject, errorMessage) {
        colors = colorsObject;
        ready = true;
        loadError = errorMessage || "";
        timeoutTimer.stop();
        themeChanged();
    }

    function _applyFallback(errorMessage) {
        _logFailure(errorMessage);
        _finalize(cloneObject(fallbackColors), errorMessage);
    }

    function _extractWallpaperPath(configText) {
        const match = /(^|\n)\s*path\s*=\s*(.+?)\s*(?=\n|$)/m.exec(configText || "");
        if (!match)
            return "";

        let path = String(match[2]).trim();
        if ((path.startsWith("\"") && path.endsWith("\"")) || (path.startsWith("'") && path.endsWith("'")))
            path = path.slice(1, -1);

        if (path.startsWith("~/"))
            path = homeDir + path.slice(1);
        else if (path.length && !path.startsWith("/"))
            path = homeDir + "/" + path;

        return path;
    }

    function _valueFromColorNode(node) {
        if (node === undefined || node === null)
            return "";
        if (typeof node === "string")
            return node;
        if (typeof node === "object") {
            if (typeof node.color === "string")
                return node.color;
            if (typeof node.hex === "string")
                return node.hex;
        }
        return "";
    }

    function _extractMatugenColor(data, key, fallback) {
        if (!data || typeof data !== "object")
            return fallback;

        let value = "";

        if (data.colors && data.colors[key]) {
            const keyed = data.colors[key];
            value = _valueFromColorNode(keyed[matugenMode]);
            if (!value)
                value = _valueFromColorNode(keyed.default);
            if (!value)
                value = _valueFromColorNode(keyed);
        }

        if (!value && data.colors && data.colors[matugenMode] && data.colors[matugenMode][key])
            value = _valueFromColorNode(data.colors[matugenMode][key]);

        if (!value && data[key])
            value = _valueFromColorNode(data[key]);

        return value || fallback;
    }

    function _buildPalette(data) {
        return {
            background: _extractMatugenColor(data, "background", fallbackColors.background),
            surfaceLow: _extractMatugenColor(data, "surface_container_low", fallbackColors.surfaceLow),
            surfaceContainer: _extractMatugenColor(data, "surface_container", fallbackColors.surfaceContainer),
            surfaceContainerHigh: _extractMatugenColor(data, "surface_container_high", fallbackColors.surfaceContainerHigh),
            surfaceContainerHighest: _extractMatugenColor(data, "surface_container_highest", fallbackColors.surfaceContainerHighest),
            surfaceLowest: _extractMatugenColor(data, "surface_container_lowest", fallbackColors.surfaceLowest),
            primary: _extractMatugenColor(data, "primary", fallbackColors.primary),
            onPrimary: _extractMatugenColor(data, "on_primary", fallbackColors.onPrimary),
            onSurface: _extractMatugenColor(data, "on_surface", fallbackColors.onSurface),
            onSurfaceVariant: _extractMatugenColor(data, "on_surface_variant", fallbackColors.onSurfaceVariant),
            outline: _extractMatugenColor(data, "outline", fallbackColors.outline),
            error: _extractMatugenColor(data, "error", fallbackColors.error)
        };
    }

    function _startMatugen(currentWallpaperPath) {
        wallpaperPath = currentWallpaperPath;
        matugenProcess.exec({
            command: [
                "sh",
                "-lc",
                "exec matugen image \"$1\" --dry-run --json hex --mode dark --source-color-index 0",
                "_",
                currentWallpaperPath
            ]
        });
    }

    Timer {
        id: timeoutTimer

        interval: 2000
        repeat: false
        onTriggered: {
            if (!root.ready)
                root._applyFallback("Timed out generating a wallpaper theme.");
        }
    }

    FileView {
        id: wallpaperConfigFile

        path: root.wallpaperConfigPath
        preload: true
        blockLoading: true
        printErrors: false

        onLoadFailed: function(error) {
            root._applyFallback("Failed to read " + root.wallpaperConfigPath + ": " + error);
        }
    }

    Process {
        id: matugenProcess

        running: false
        command: []

        onStarted: {
            root._matugenStdout = "";
            root._matugenStderr = "";
        }

        stdout: StdioCollector {
            onStreamFinished: {
                root._matugenStdout = text.trim();
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                root._matugenStderr = text.trim();
            }
        }

        onExited: function(exitCode) {
            if (root.ready)
                return;

            if (exitCode !== 0) {
                const message = root._matugenStderr || ("matugen exited with code " + exitCode + ".");
                root._applyFallback(message);
                return;
            }

            if (!root._matugenStdout.length) {
                root._applyFallback("matugen returned no theme data.");
                return;
            }

            try {
                const parsed = JSON.parse(root._matugenStdout);
                root._finalize(root._buildPalette(parsed), "");
            } catch (error) {
                root._applyFallback("Failed to parse matugen output: " + error);
            }
        }
    }
}
