{ pkgs }:

with pkgs; [

  # General packages for development and system management
  coreutils
  killall
  openssh
  pandoc
  wget
  zip
  reattach-to-user-namespace

  # Encryption and security tools
  age
  age-plugin-yubikey
  bitwarden-cli
  gnupg
  libfido2
  pinentry
  pinentry_mac
  yubikey-manager

  # Text and terminal utilities
  alacritty
  bat
  cowsay
  diff-so-fancy
  fzf
  htop
  jq
  ripgrep
  tldr
  tmux
  tree
  unrar
  unzip

  # Development Tools
  vscode

  # Productivity & Communication
  alfredWorkflows.bitwarden
  alfredWorkflows.hue
  alfredWorkflows.numi-cli
  alfredWorkflows.spotify-mini-player
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

  # Python
  python311
  python311Packages.black
  python311Packages.pip
  python311Packages.pylint
  python311Packages.watchdog
  pipenv

  # Nix
  nixd
  nixpkgs-fmt

]
