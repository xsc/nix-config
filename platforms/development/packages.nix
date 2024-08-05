{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [

      # Text and terminal utilities
      tmux
      wezterm

      # Encryption and security tools
      age-plugin-yubikey
      libfido2
      nextdns
      yubikey-manager

      # Development Tools
      k6
      scrcpy
      vscode

      # Cloud-related tools and SDKs
      docker
      docker-compose
      awscli2
      aws-sam-cli
      awsume
      azure-cli

      # --- Multimedia
      ffmpeg

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
    ];
}
