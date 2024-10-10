{theme, ...}: let
  T = theme.wezterm;
  fontSize = T.font.fontSize;
in {
  home.file.".config/wezterm/wezterm.lua" = {
    text = ''
      local wezterm = require 'wezterm'
      local mux = wezterm.mux
      local config = {}

      config.term = "wezterm"
      config.front_end = "WebGpu"

      -- Maximize on Startup
      wezterm.on("gui-startup", function()
        local tab, pane, window = mux.spawn_window{}
        window:gui_window():maximize()
      end)

      -- Theme
      config.color_scheme = "${T.colorscheme.name}"
      config.font = wezterm.font "${T.font.fontFamily}"
      config.font_size = ${builtins.toString fontSize}

      -- Appearance
      config.enable_tab_bar = false
      config.window_padding = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8,
      }
      config.initial_rows = 60

      return config
    '';
  };

  home.file.".config/wezterm/colors/everforest-dark.toml" = {
    source = ./everforest-dark.toml;
  };
}
