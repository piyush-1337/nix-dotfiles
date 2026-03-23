{ pkgs, ... }:

let
  interactive-screenshot = pkgs.writeShellScriptBin "interactive-screenshot" ''
    AREA=$(echo -e "Screen\nSelection" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Capture Area:" --lines 2)

    [ -z "$AREA" ] && exit 0

    ACTION=$(echo -e "Copy\nSave\nBoth" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Action:" --lines 3)

    [ -z "$ACTION" ] && exit 0

    GB_AREA="screen"
    [ "$AREA" = "Selection" ] && GB_AREA="area"

    GB_ACTION="copy"
    [ "$ACTION" = "Save" ] && GB_ACTION="save"
    [ "$ACTION" = "Both" ] && GB_ACTION="copysave"

    sleep 0.5
    ${pkgs.grimblast}/bin/grimblast "$GB_ACTION" "$GB_AREA"
  '';
in
{
  home.packages = with pkgs; [
    interactive-screenshot
    grimblast
    wofi
  ];
}
