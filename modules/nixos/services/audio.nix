{ ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.alsa.enablePersistence = true;
}
