{ pkgs, ... }:

let
  interactive-screenshot = pkgs.writeShellScriptBin "interactive-screenshot" ''
    # 1. Prompt for the capture area
    AREA=$(echo -e "Screen\nSelection" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Capture Area:" --lines 2)

    # Exit if user hits Escape
    [ -z "$AREA" ] && exit 0

    # 2. Prompt for the action
    ACTION=$(echo -e "Copy\nSave\nBoth" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Action:" --lines 3)

    # Exit if user hits Escape
    [ -z "$ACTION" ] && exit 0

    # 3. Map selections to grimblast arguments
    GB_AREA="screen"
    [ "$AREA" = "Selection" ] && GB_AREA="area"

    GB_ACTION="copy"
    [ "$ACTION" = "Save" ] && GB_ACTION="save"
    [ "$ACTION" = "Both" ] && GB_ACTION="copysave"

    # 4. Execute the final command
    ${pkgs.grimblast}/bin/grimblast "$GB_ACTION" "$GB_AREA"
  '';
in
{
  # Install the script and its dependencies
  home.packages = with pkgs; [
    interactive-screenshot
    grimblast
    wofi
  ];
}
