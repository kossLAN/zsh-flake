{
  description = "My ZSH dot files in flake format";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forEachSystem = fn:
      nixpkgs.lib.genAttrs
      ["x86_64-linux" "aarch64-linux"]
      (system: fn system nixpkgs.legacyPackages.${system});

    overlay = final: prev: {
      zsh = prev.stdenv.mkDerivation {
        inherit (self.packages.${prev.system}.default) name;

        buildCommand = ''
          mkdir -p $out
          cp -r ${self.packages.${prev.stdenv.hostPlatform.system}.default}/* $out/
        '';

        meta = {
          inherit (prev.zsh.meta) platforms;
          description = "Custom zsh shell";
          shellPath = "/bin/zsh";
        };

        passthru = {
          shellPath = "/bin/zsh";
        };
      };
    };
  in {
    # Package so you can test this out, without installing :3.
    packages = forEachSystem (system: pkgs: rec {
      zsh = import ./nix/wrapZsh.nix {
        inherit pkgs;
        lib = nixpkgs.lib;
      };

      default = zsh;
    });

    # Export the overlay
    overlays.default = overlay;
  };
}
