{ agenix, alfred, pkgs, ... }:

{
  imports = [
    ../base
    ../development
    ./packages
    ./dock
    # ./utils/alias-apps
    ./homebrew
    ./launchd.nix
    agenix.darwinModules.default
    alfred.darwinModules.activateWorkflows
  ];

  home-manager.sharedModules = [
    {
      home.stateVersion = "21.11";
      manual.manpages.enable = true;
      launchd.enable = true;
    }
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixVersions.latest;

    gc = {
      user = "root";
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.overlays = [ alfred.overlays.default ];

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Enable fonts dir
  fonts.packages = with pkgs; [ fira-code fira-code-nerdfont monaspace ];

  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = { LSQuarantine = false; };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = { _FXShowPosixPathInTitle = false; };

      menuExtraClock = {
        Show24Hour = true;
        ShowSeconds = false;
        ShowDate = 0;
        ShowDayOfWeek = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      nonUS.remapTilde = true;
    };
  };
}
