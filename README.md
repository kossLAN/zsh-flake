# zsh-flake

A shrimple personal zsh dotfiles flake :3

## Why?

I'd like to use my zsh dotfiles on Non-NixOS systems and have them be systemwide, the current suggested way of configuring zsh with NixOS is by using home-manager and I was not very happy with that solution, this flake overrides the nixpkgs version of zsh to enable the use of it systemwide.

## Installation

### NixOS Configuration Installation

```nix
programs.zsh.enable = true;

nixpkgs.overlays = [
    # replace <zsh-input> with the name of your input
    <zsh-input>.overlays.default
];
```

### Testing

```sh
$ nix run github:kosslan/zsh-flake
```