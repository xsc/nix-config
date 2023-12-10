{}:

let
  fontFamily = "Fira Code";
  fontSize = 12;
in
{
  vim = {
    background = "dark";
    colorscheme = {
      name = "everforest";
      pluginName = "everforest";
    };
    lightline = "ayu_mirage";
  };

  alacritty = {
    font = { inherit fontFamily fontSize; };
    colorscheme = { name = "everforest_dark"; };
  };

  tmux = {
    status = {
      fg = "yellow";
      bg = "black";
    };
  };

  vscode = {
    font = { inherit fontFamily fontSize; };
    colorscheme = {
      name = "Everforest Dark";
      publisher = "sainnhe";
      plugin = "everforest";

      settings = {
        "everforest.highContrast" = true;
        "everforest.darkContrast" = "soft";
        "everforest.darkWorkbench" = "high-contrast";
      };
    };
  };

  wezterm = {
    font = {
      inherit fontFamily;
      fontSize = fontSize - 0.3;
    };
    colorscheme = {
      name = "everforest-dark";
    };
  };
}
