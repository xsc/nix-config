{ ... }:

let
  homebrewBrews = import ./brews.nix { };
  homebrewCasks = import ./casks.nix { };
  homebrewMasApps = import ./app-store.nix { };
in
{
  homebrew.enable = true;
  homebrew.brews = homebrewBrews;
  homebrew.casks = homebrewCasks;
  homebrew.masApps = homebrewMasApps;
}
