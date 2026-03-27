{ ... }:

{
  services.mako = {
    enable = true;

    settings = {
      padding = "15";
      margin = "10";
      borderSize = 2;
      borderRadius = 8;
      defaultTimeout = 5000; # Disappears after 5 seconds
      layer = "overlay"; # Ensures it renders above fullscreen windows

      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "over #313244";
    };
    extraConfig = ''
      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
    '';
  };
}
