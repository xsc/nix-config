{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Text and terminal utilities
    tmux
    wezterm

    # Encryption and security tools
    age-plugin-yubikey
    libfido2
    yubikey-manager
    wireguard-tools

    # Development Tools
    k6
    scrcpy

    # Cloud-related tools and SDKs
    docker
    docker-compose
    awscli2
    aws-sam-cli
    awsume
    azure-cli
    python312Packages.cfn-lint

    # --- Multimedia
    ffmpeg

    # --- Language-specific Packages

    # Clojure/Java
    openjdk17
    leiningen
    clj-kondo
    iced-repl # via vim-plugins-github overlay

    # JS/TS
    eslint_d
    nodejs_18
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript-language-server
    prettierd
    yarn

    # Kotlin
    kotlin-language-server
    ktlint

    # Markdown
    markdownlint-cli2
    nodePackages.alex

    # PHP
    php

    # Python
    python312
    python312Packages.black
    python312Packages.flake8
    python312Packages.pip
    python312Packages.pylint
    python312Packages.watchdog
    python312Packages.virtualenv
    pipenv
    pipx
  ];
}
