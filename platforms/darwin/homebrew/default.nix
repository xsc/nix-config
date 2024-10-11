_: let
  homebrewBrews = import ./brews.nix {};
  homebrewCasks = import ./casks.nix {};
  homebrewMasApps = import ./app-store.nix {};
in {
  homebrew = {
    enable = true;
    brews = homebrewBrews;
    casks = homebrewCasks;
    masApps = homebrewMasApps;
  };
}
