{ pkgs, lib }:

with pkgs; [

  # General packages for development and system management
  coreutils
  home-manager
  killall
  openssh
  pandoc
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  bitwarden-cli
  gnupg
  libfido2
  nextdns
  pinentry
  pinentry-curses
  yubikey-manager

  # Text and terminal utilities
  alacritty
  bat
  cowsay
  diff-so-fancy
  haskellPackages.kmonad
  fzf
  htop
  jq
  ripgrep
  tldr
  tmux
  tree
  unzip
  wezterm

  # Development Tools
  vscode

  # Communication
  slack

  # Cloud-related tools and SDKs
  docker
  docker-compose
  awscli2
  azure-cli

  # --- Language-specific Packages

  # Clojure/Java
  openjdk17
  leiningen
  clj-kondo
  iced-repl # via vim-plugins-github overlay

  # JS/TS
  nodejs_18
  nodePackages.prettier

  # Python
  python311
  python311Packages.black
  python311Packages.flake8
  python311Packages.pip
  python311Packages.pylint
  python311Packages.watchdog
  pipenv

  # Nix
  nixd
  nixpkgs-fmt

]
++ (pkgs.callPackage ./fonts.nix { })
++ (
  if pkgs.stdenv.isDarwin
  then
    (pkgs.callPackage ./darwin.nix { })
      ++ (pkgs.callPackage ./alfred-workflows.nix { })
  else [ ]
)
