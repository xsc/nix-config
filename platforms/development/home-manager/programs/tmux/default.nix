{
  pkgs,
  lib,
  theme,
  ...
}: let
  T = theme.tmux;
in {
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [sensible yank];
    clock24 = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 5;
    historyLimit = 50000;
    extraConfig =
      ''
        set -g default-terminal "xterm-256color"
        # set-option -sa terminal-overrides ",*-256color*:TC"
        set-option -sa terminal-overrides ",*-256color:RGB"
        set-option -g status-style fg=${T.status.fg},bg=${T.status.bg}
        set-window-option -g window-status-current-style fg=${T.status.fg},bold,bg=default
      ''
      + lib.fileContents ./tmux.conf;
  };
}
