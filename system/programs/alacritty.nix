{ config, pkgs, lib, theme, ... }:

let T = theme.alacritty;
in {
  alacritty = {
    enable = true;
    settings = {
      import = [ pkgs.alacritty-theme.${T.colorscheme.name} ];

      window = {
        opacity = 1.0;
        padding = {
          x = 4;
          y = 4;
        };
      };

      font = {
        normal = {
          family = T.font.fontFamily;
          style = "Regular";
        };
        size = T.font.fontSize;
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
