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
  gnupg
  libfido2
  pinentry
  yubikey-manager

  # Cloud-related tools and SDKs
  #
  # docker marked broken as of Nov 15, 2023
  # https://github.com/NixOS/nixpkgs/issues/267685
  #
  # docker
  # docker-compose
  #
  awscli2
  azure-cli

  # Clojure/Java
  openjdk17
  leiningen
  clj-kondo

  # Python
  python311
  python311Packages.black
  python311Packages.pip
  python311Packages.pylint
  python311Packages.watchdog
  pipenv

  # Text and terminal utilities
  alacritty
  diff-so-fancy
  fzf
  htop
  jq
  ripgrep
  tree
  tmux
  unrar
  unzip

  # Fonts
  fira-code

  # Others
  cowsay
  reattach-to-user-namespace
]
