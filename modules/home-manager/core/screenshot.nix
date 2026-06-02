{ pkgs, ... }:

let
  interactive-screenshot = pkgs.writeShellScriptBin "interactive-screenshot" ''
    AREA=$(echo -e "Screen\nSelection" | ${pkgs.wofi}/bin/wofi --dmenu --prompt "Capture Area:" --lines 2)

    [ -z "$AREA" ] && exit 0

    # Wait a moment for wofi to close
    sleep 0.5

    # Ensure Pictures directory exists
    mkdir -p ~/Pictures

    if [ "$AREA" = "Selection" ]; then
      ${pkgs.grim}/bin/grim -t ppm -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.satty}/bin/satty --filename - --fullscreen --output-filename ~/Pictures/Screenshot-$(date '+%Y%m%d-%H%M%S').png
    else
      ${pkgs.grim}/bin/grim -t ppm - | ${pkgs.satty}/bin/satty --filename - --fullscreen --output-filename ~/Pictures/Screenshot-$(date '+%Y%m%d-%H%M%S').png
    fi
  '';
in
{
  home.packages = with pkgs; [
    interactive-screenshot
    grim
    slurp
    satty
    wofi
  ];
}
