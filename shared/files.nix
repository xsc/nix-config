{ pkgs, config, lib, ... }:

{
  ".lein/profiles.clj" = {
    text = lib.fileContents ./config/lein/profiles.clj;
  };
}
