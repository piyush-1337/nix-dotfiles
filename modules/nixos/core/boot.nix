{ ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "spd5118" ];
  boot.kernelParams = [
    "nvidia.NVreg_EnableS0ixPowerManagement=1"
    "mem_sleep_default=s2idle"
  ];
}
