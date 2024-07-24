{ pkgs, lib, ... }:
{
  zsh = {
    enable = true;
    autocd = false;
    cdpath = [ "~/.local/share/src" ];

    shellAliases = {
      ll = "ls -l --color=auto";
      ls = "ls --color=auto";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "git-prompt"
        "history"
        "z"
      ];
    };

    initExtra = lib.mkDefault ''
      # VI Mode
      ZVM_INIT_MODE=sourcing
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd v edit-command-line

      # Prompt
      function collapse_pwd {
        echo $(pwd | sed -e "s,^$HOME,~,")
      }

      function prompt_char {
        echo '$';
      }

      PROMPT='%n@%M:%{$fg[yellow]%}$(collapse_pwd)%{$reset_color%}$(git_super_status) $(prompt_char) '
      RPROMPT=""
      ZSH_THEME_GIT_PROMPT_PREFIX=" on "
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_SEPARATOR=" ∆ "
      ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[magenta]%}"
      ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[yellow]%}%{●%G%}"
      ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
      ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[green]%}%{+%G%}"
      ZSH_THEME_GIT_PROMPT_BEHIND=" %{$fg[red]%}%{↓%G%}"
      ZSH_THEME_GIT_PROMPT_AHEAD=" %{$fg[blue]%}%{↑%G%}"
      ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[gray]%}%{⧖%G%}"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

      # FZF
      source "${pkgs.fzf}/share/fzf/completion.zsh"
      source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
    '';

    initExtraFirst = lib.mkDefault ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Environment
      export PATH=$PATH:~/.bin:/opt/homebrew/bin:~/.local/bin
      export LC_ALL=en_US.UTF-8
      export LANG=en_US.UTF-8

      # Clear
      zsh_clear() { command clear; zle redisplay; }
      zle -N zsh_clear
      bindkey -M viins '^@' zsh_clear
    '';

  };
}
