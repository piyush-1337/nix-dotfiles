{ ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      mtu = 1440;
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      ipv6 = false;
      data-root = "/home/piyush/docker-data/";
      userland-proxy = false;
    };
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
