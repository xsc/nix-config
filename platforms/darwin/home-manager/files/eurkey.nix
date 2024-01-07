{ pkgs, ... }:
let
  eurkey = pkgs.fetchFromGitHub {
    owner = "xsc";
    repo = "eurkey-mac";
    rev = "498a7203309d1cfdb3a81960edc812c38fd8acf3";
    sha256 = "sha256-/Tmm9dkE1HILryzQ9e6or+Z9geCzS5yZ8GLN3ak22pU=";
  };
in
{
  "Library/Keyboard Layouts/EurKEY.icns" = {
    source = eurkey + /EurKEY.icns;
  };

  "Library/Keyboard Layouts/EurKEY.keylayout" = {
    source = eurkey + /EurKEY.keylayout;
  };
}
