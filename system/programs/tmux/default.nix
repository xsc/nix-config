{ config, pkgs, lib, userData, ... }:

{
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
    extraConfig = lib.fileContents ./tmux.conf;
  };
}
