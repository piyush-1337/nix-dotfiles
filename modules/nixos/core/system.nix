{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.settings.narinfo-cache-negative-ttl = 31536000;
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://hyprland.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbQ+2o0p3iKl6L8+IYbtr7G0bM="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    proton-vpn-cli
  ];

  programs.nix-ld.enable = true;
}
