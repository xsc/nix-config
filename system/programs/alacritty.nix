{ config, pkgs, lib, ... }:

{
  alacritty = {
    enable = true;
    settings = {
      import = [ pkgs.alacritty-theme.solarized_light ];

      window = {
        opacity = 1.0;
        padding = {
          x = 4;
          y = 4;
        };
      };

      font = {
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 12)
        ];
      };

      title = "Terminal";
      dynamic_padding = true;
      decorations = "full";
      class = {
        instance = "Alacritty";
        general = "Alacritty";
      };

    };
  };
}
