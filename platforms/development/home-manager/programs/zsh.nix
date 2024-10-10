{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    shellAliases = {
      awsume = ". awsume";
      iced-repl = "iced repl with-profile +iced";
    };

    oh-my-zsh = {
      plugins = [
        "history"
      ];
    };

    initExtra = lib.mkForce ''
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

      # asciinema: Simple prompt
      if [ ! "$ASCIINEMA_REC" -eq "1" ]; then
        # istheinternetonfire
        if [ $[$RANDOM % 100] -lt 10 ]; then
            host -t txt istheinternetonfire.com | cut -f 2 -d '"' | cowsay -f moose
        fi

        PROMPT='%n:%{$fg[yellow]%}$(collapse_pwd)%{$reset_color%}$(git_super_status) $(prompt_char) '
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

        # tmux
        _not_inside_tmux() { [[ -z "$TMUX" ]] }

        ensure_tmux_is_running() {
          if _not_inside_tmux; then
            tmux attach 2> /dev/null || tmux new-session -s dev;
          fi
        }

        ensure_tmux_is_running
      else
        PROMPT='$(collapse_pwd) $(prompt_char) '
        RPROMPT=""
      fi

      # FZF
      source "${pkgs.fzf}/share/fzf/completion.zsh"
      source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
    '';
  };
}
