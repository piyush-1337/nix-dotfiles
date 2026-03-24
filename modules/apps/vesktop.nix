{ pkgs, ... }:
{
  home.packages = [
    pkgs.vesktop
  ];

  home.file.".config/vesktop/settings.json".text = ''
    {
      "discordBranch": "stable",
      "arRPC": true,
      "splashColor": "rgb(205, 214, 244)",
      "splashBackground": "rgb(30, 30, 46)",
      "enableReactDevtools": false,
      "frameless": false,
      "transparent": false,
      "winCtrlQ": false,
      "disableMinSize": false,
      "winNativeTitleBar": false,
      "plugins": {},
      "notifications": {
        "position": "bottom-right"
      },
      "hardwareAcceleration": true,
      "electronOzonePlatformHint": "wayland"
    }
  '';
}
