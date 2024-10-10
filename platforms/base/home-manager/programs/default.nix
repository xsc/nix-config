{...}: {
  imports = [
    ./git.nix
    ./nvim
    ./zsh.nix
  ];

  programs.gpg.enable = true;

  programs.ssh = {
    enable = true;

    extraConfig = ''
      Include config.d/*.ssh_config
    '';
  };
}
