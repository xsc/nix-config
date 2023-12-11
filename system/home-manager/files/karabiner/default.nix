{ pkgs, ... }:

{
  ".config/karabiner/karabiner.json" = {
    source = ./karabiner.json;
  };

  ".config/karabiner/assets" = {
    source = ./assets;
  };
}
