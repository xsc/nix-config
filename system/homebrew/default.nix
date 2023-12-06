{ ... }:

let homebrewCasks = import ./casks.nix {};
    homebrewMasApps = import ./app-store.nix {};
in {
  homebrew.enable = true;
  homebrew.casks = homebrewCasks;
  homebrew.masApps = homebrewMasApps;
}
