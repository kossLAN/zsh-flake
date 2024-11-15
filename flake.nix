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
    # Define a package for your project
    packages = forEachSystem (system: pkgs: rec {
      zsh = import ./nix/wrapZsh.nix {
        inherit pkgs;
        lib = nixpkgs.lib;
      };

      default = zsh;
    });
  };
}
