{ ... }:

{
  services.mako = {
    enable = true;

    settings = {
      padding = "15";
      margin = "10";
      border-size = 2;
      border-radius = 8;
      default-timeout = 5000;
      layer = "overlay";

      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #313244";
    };

    extraConfig = ''
      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
    '';
  };
}
