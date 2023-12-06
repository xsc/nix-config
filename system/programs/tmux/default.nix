{ config, pkgs, lib, userData, ... }:

{
  tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = tmux-colors-solarized;
        extraConfig = ''
          set -g @colors-solarized 'light'
          '';
      }
    ];
    terminal = "alacritty";
    clock24 = true;
    prefix = "C-a";
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 5;
    historyLimit = 50000;
    extraConfig = lib.fileContents ./tmux.conf;
  };
}
