{ ... }:

{
  imports = [
    ./redshift.nix
    ./ulauncher.nix
  ];

  # Locale/TImezone
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  location = {
    provider = "manual";
    latitude = 48.13;
    longitude = 11.57;
  };

  # X Server
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
    };

    desktopManager = {
      cinnamon.enable = true;
    };

  };

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
}
