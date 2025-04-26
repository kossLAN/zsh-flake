{
  pkgs,
  lib,
  ...
}: let
  conf = import ./config.nix {inherit pkgs lib;};
in
  pkgs.symlinkJoin {
    name = "zsh";
    paths = [pkgs.zsh];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      # When it comes to zsh options, I'm probably missing some important ones,
      # if you know of any that I should add please make an issue for me, thank you.
      # The sh comment before the multiline is for syntax highlighting in neovim.
      mkdir -p $out/etc/zsh
      cp ${pkgs.writeText "zshrc"
        ''
          # Auto suggestions
          ${
            if conf.autoSuggestions
            then ''
              source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
              ZSH_AUTOSUGGEST_STRATEGY=(history)
            ''
            else ""
          }

          # History configuration
          HISTFILE="$HOME/.zsh_history"
          HISTSIZE=10000
          SAVEHIST=10000
          PATH=${lib.makeBinPath conf.extraPackages}:$PATH

          setopt AUTO_CD
          setopt AUTO_PUSHD
          setopt PUSHD_IGNORE_DUPS
          setopt EXTENDED_HISTORY
          setopt SHARE_HISTORY
          setopt HIST_EXPIRE_DUPS_FIRST
          setopt HIST_IGNORE_DUPS
          setopt HIST_IGNORE_SPACE
          setopt HIST_VERIFY
          setopt INTERACTIVE_COMMENTS

          # Basic autocompletion
          autoload -Uz compinit
          compinit

          # Plugins import
          ${lib.concatMapStrings (plugin: ''
              if [[ -f "${plugin}" ]]; then
                source "${plugin}"
              fi
            '')
            conf.plugins}

          ${conf.extraZshrc}
        ''} $out/etc/zsh/.zshrc

      wrapProgram $out/bin/zsh \
        --set ZDOTDIR "$out/etc/zsh"
    '';
  }
