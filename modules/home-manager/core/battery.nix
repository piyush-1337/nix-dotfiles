{ pkgs, ... }:

{
  services.batsignal = {
    enable = true;
    extraArgs = [
      "-w"
      "20"
      "-c"
      "10"
      "-d"
      "2"
    ];
  };
  systemd.user.services.batsignal.Install.WantedBy = pkgs.lib.mkForce [ "default.target" ];
}
