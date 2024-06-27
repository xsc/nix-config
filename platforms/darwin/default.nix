{ agenix, alfred, userData, pkgs, ... }:

{
  imports = [
    ../shared
    ./dock
    ./utils/alias-apps
    ./homebrew
    ./home-manager
    ./launchd.nix
    agenix.darwinModules.default
    alfred.darwinModules.activateWorkflows
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-users = [ "@admin" "${userData.user}" ];

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

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs;
    [ agenix.packages."${pkgs.system}".default ]
    ++ (import ../shared/packages { inherit pkgs; })
    ++ (import ./packages { inherit pkgs; });

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
    };
  };
}
