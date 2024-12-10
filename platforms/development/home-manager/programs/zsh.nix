{pkgs, ...}: {
  programs.zsh = {
    shellAliases = {
      aws-populate = "${pkgs.writeShellScript "aws-populate" ''
        # 'awsume' needs full paths to the credential process, which we can achieve by setting
        # this environment variable
        export AWS_SSO_CREDENTIAL_PROCESS_NAME="$(which aws-sso-util) credential-process"
        aws-sso-util configure populate "$@"
      ''}";
      awsume = ". awsume";
      iced-repl = "iced repl with-profile +iced";
    };

    initExtraFirst = ''
      # Prompt without hostname
      ZSH_PROMPT='%n:%{$fg[yellow]%}$(collapse_pwd)%{$reset_color%}$(git_super_status) $(prompt_char) '
    '';

    initExtra = ''
      # tmux
      _should_start_tmux() { [[ -z "$TMUX" ]] && [ ! "$ASCIINEMA_REC" -eq "1" ] }
      if _should_start_tmux; then
        tmux attach 2> /dev/null || tmux new-session -s dev;
      fi
    '';
  };
}
