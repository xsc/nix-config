{ pkgs }:

with pkgs; [

  # General packages for development and system management
  coreutils
  gnused
  killall
  openssh
  pandoc
  wget
  zip

  # Encryption and security tools
  age
  age-plugin-yubikey
  gnupg
  libfido2
  nextdns
  yubikey-manager

  # Text and terminal utilities
  alacritty
  bat
  cowsay
  diff-so-fancy
  fx
  fzf
  htop
  jq
  kanata-custom
  patchutils_0_4_2
  ripgrep
  tldr
  tmux
  tree
  unzip
  wezterm

  # Media Utilities
  exiftool
  ffmpeg_7

  # Development Tools
  k6
  scrcpy
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
  yarn

  # Kotlin
  kotlin-language-server
  ktlint

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
  python311Packages.virtualenv
  pipenv
  pipx

  # Nix
  nixd
  nixpkgs-fmt
]
