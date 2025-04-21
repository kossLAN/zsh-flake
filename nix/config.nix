# This is where personal configuration is expected to be, I'll probably add more, but for the moment this
# will do.
{
  pkgs,
  lib,
  ...
}: let
  oh-my-zsh = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "fd01fd66ce27c669e5ffaea94460a37423d1e134";
    sha256 = "sha256-5G96Iae543/CVmwRVpwAlbRB7vf+t/E2fl0pOu+RM6Y=";
  };
in {
  # Whether or not to enable auto suggestions
  autoSuggestions = true;

  extraPackages = with pkgs; [
    fzf
  ];

  # Additional .zshrc configuration that you can add that will be appended to the .zshrc
  extraZshrc = ''
    # Stupid thing broken in NixOS module I think
    autoload -Uz add-zsh-hook

    # Movement bindings
    bindkey -v
    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word

    # Special plugin cases
    source <(fzf --zsh)
  '';

  # A list of path's to a plugin
  plugins = [
    # The ZSH theme that I use, I think it looks good, go check it out.
    "${pkgs.fetchFromGitHub {
      owner = "zthxxx";
      repo = "jovial";
      rev = "701ea89b6dd2b9859dab32bd083a16643b338b47";
      sha256 = "sha256-VVGBG0ZoL25v+Ht1QbnZMc1TqTiJvr211OvyVwNc3bc=";
    }}/jovial.zsh-theme"

    "${pkgs.fetchFromGitHub {
      owner = "zthxxx";
      repo = "zsh-history-enquirer";
      rev = "6fdfedc4e581740e7db388b36b5e66f7c86e8046";
      sha256 = "sha256-/RGBIoieqexK2r4onFbXAt4ALEIb17mn/all0P1xFkE=";
    }}/zsh-history-enquirer.plugin.zsh"

    "${pkgs.fetchFromGitHub {
      owner = "zsh-users";
      repo = "zsh-syntax-highlighting";
      rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
      sha256 = "sha256-4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
    }}/zsh-syntax-highlighting.zsh"

    "${oh-my-zsh}/plugins/git/git.plugin.zsh"
    "${oh-my-zsh}/plugins/urltools/urltools.plugin.zsh"
    "${oh-my-zsh}/plugins/bgnotify/bgnotify.plugin.zsh"
  ];
}
