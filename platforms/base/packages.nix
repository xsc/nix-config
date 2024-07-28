{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs; [
      # General packages for development and system management
      coreutils
      duply
      duplicity
      gnused
      killall
      openssh
      pandoc
      wget
      zip

      # Encryption and security tools
      age
      gnupg

      # Terminal Utilities
      bat
      cowsay
      diff-so-fancy
      fx
      fzf
      gotop
      jq
      patchutils_0_4_2
      ripgrep
      tldr
      tree
      unzip

      # Python
      python311

      # Nix
      nixd
      nixpkgs-fmt
    ];
}
