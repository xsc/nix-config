{
  config,
  lib,
  pkgs,
  ...
}: {
  options.theme = {
    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "Fira Code";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 10;
    };

    tmux = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        status = {
          fg = "yellow";
          bg = "black";
        };
      };
    };

    vim = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        background = "dark";
        colorscheme = {
          name = "everforest";
          pluginName = "everforest-nvim";
        };
        lightline = "ayu_mirage";
      };
    };

    wezterm = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        colorscheme = {
          name = "everforest-dark";
        };
      };
    };
  };

  config = let
    cfg = config.theme;
  in {
    home-manager.extraSpecialArgs = {
      theme = {
        inherit (cfg) tmux vim;
        wezterm = {
          font = {
            fontFamily = cfg.fontFamily;
            fontSize = cfg.fontSize - 0.3;
          };
          inherit (cfg.wezterm) colorscheme;
        };
      };
    };

    fonts.packages = with pkgs; [
      fira-code-nerdfont
      fira-code
      monaspace
    ];
  };
}
