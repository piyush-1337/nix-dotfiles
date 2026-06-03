{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # if i ever want to go back to hybrid mode uncomment intel drivers
    extraPackages = with pkgs; [
      # intel-media-driver
      # intel-ocl
      # intel-vaapi-driver
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # VRAM patch
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-niri-vram-fix.json".text = ''
    {
        "rules": [
            {
                "pattern": {
                    "feature": "procname",
                    "matches": "niri"
                },
                "profile": "Limit Free Buffer Pool On Wayland Compositors"
            }
        ],
        "profiles": [
            {
                "name": "Limit Free Buffer Pool On Wayland Compositors",
                "settings": [
                    {
                        "key": "GLVidHeapReuseRatio",
                        "value": 0
                    }
                ]
            }
        ]
    }
  '';

  # lock P0 in niri
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nvidia-lock-clocks" ''
      ${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lmc 7001
      ${config.hardware.nvidia.package.bin}/bin/nvidia-smi -lgc tdp,unlimited
    '')
    (writeShellScriptBin "nvidia-reset-clocks" ''
      ${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rmc
      ${config.hardware.nvidia.package.bin}/bin/nvidia-smi -rgc
    '')
  ];

  security.sudo.extraRules = [
    {
      users = [
        "piyush"
        "push"
      ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nvidia-lock-clocks";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nvidia-reset-clocks";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaPersistenced = true;
    # uncomment when switching to hybrid mode
    # prime = {
    #   offload.enable = true;
    #   offload.enableOffloadCmd = true;
    #
    #   intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:1:0:0";
    # };
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
