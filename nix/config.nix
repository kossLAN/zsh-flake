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
  extraZshrc = /*sh*/ '' 
    # Stupid thing broken in NixOS module I think
    autoload -Uz add-zsh-hook

    # Movement bindings
    bindkey -v
    bindkey "^[[1;5C" forward-word
    bindkey "^[[1;5D" backward-word

    # Special plugin cases
    source <(fzf --zsh)

    # Minimal Prompt
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enable git 
    zstyle ':vcs_info:*' check-for-changes true
    precmd() { vcs_info }

    setopt prompt_subst
    PROMPT='%F{cyan}%~%f  '
    # RPROMPT='%F{lightblue}$(git_prompt_info)%f'
    RPROMPT='$vcs_info_msg_0_'
    zstyle ':vcs_info:git*' formats "%b %m%u%c "
    # zstyle ':vcs_info:git*' formats "(%{$fg[lightblue]%}%b)%{$reset_color%}%u%c%{$reset_color%} "
  '';

  # A list of path's to a plugin
  plugins = [
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

    "${oh-my-zsh}/plugins/urltools/urltools.plugin.zsh"
    "${oh-my-zsh}/plugins/bgnotify/bgnotify.plugin.zsh"
  ];
}
