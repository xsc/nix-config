{ pkgs }:

with pkgs; [

  # General packages for development and system management
  coreutils
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
  yubikey-manager

  # Text and terminal utilities
  alacritty
  bat
  cowsay
  diff-so-fancy
  fzf
  htop
  jq
  kanata-custom
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
  aws-sam-cli
  awsume
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

  # Kotlin
  kotlin-language-server

  # Markdown
  markdownlint-cli2
  nodePackages.markdown-link-check

  # PHP
  php

  # Python
  python311
  python311Packages.black
  python311Packages.flake8
  python311Packages.pip
  python311Packages.pylint
  python311Packages.watchdog
  pipenv
  pipx

  # Nix
  nixd
  nixpkgs-fmt
]
