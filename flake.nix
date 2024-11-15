{
  description = "My zsh dot files in flake format";

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
  in {
    # Overlay for using this in system configurations.
    overlays.default = forEachSystem (system: (final: prev: {
      zsh = self.packages.zsh.system.default;
    }));

    # Package so you can test this out, without installing :3.
    packages = forEachSystem (system: pkgs: rec {
      zsh = import ./nix/wrapZsh.nix {
        inherit pkgs;
        lib = nixpkgs.lib;
      };

      default = zsh;
    });
  };
}
