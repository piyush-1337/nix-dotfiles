{
  description = "Development environment for Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          lua-language-server
          stylua
        ];

        shellHook = ''
          export NVIM_CONFIG_DEV=1
        '';
      };
    };
}
