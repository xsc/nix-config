{ config, pkgs, lib, theme, ... }:

let T = theme.tmux;
in {
  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
    ];
    terminal = "alacritty";
    clock24 = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 5;
    historyLimit = 50000;
    extraConfig = ''
      set-option -a terminal-overrides ",alacritty:RGB"
      set-option -g status-style fg=${T.status.fg},bg=${T.status.bg}
      set-window-option -g window-status-current-style fg=${T.status.fg},bold,bg=default
    '' + lib.fileContents ./tmux.conf;
  };
}
