{pkgs, ...}: {
  programs.tmux.extraConfig = ''
    set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh"
  '';
}
