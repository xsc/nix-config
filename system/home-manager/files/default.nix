{ pkgs, config, lib, theme, ... }:

let
  eurkey = pkgs.fetchFromGitHub {
    owner = "xsc";
    repo = "eurkey-mac";
    rev = "498a7203309d1cfdb3a81960edc812c38fd8acf3";
    sha256 = "sha256-/Tmm9dkE1HILryzQ9e6or+Z9geCzS5yZ8GLN3ak22pU=";
  };
  T = theme.wezterm;
in
{
  # --- EurKEY
  "Library/Keyboard Layouts/EurKEY.icns" = {
    source = eurkey + /EurKEY.icns;
  };

  "Library/Keyboard Layouts/EurKEY.keylayout" = {
    source = eurkey + /EurKEY.keylayout;
  };

  # --- gpg-agent
  ".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
      default-cache-ttl 1800
      max-cache-ttl 7200
    '';
  };

  # --- Leiningen
  ".lein/profiles.clj" = {
    source = ./lein/profiles.clj;
  };

  # --- Karabiner
  ".config/karabiner" = {
    source = ./karabiner;
  };

  #--- Rectangle
  "Library/Application Support/Rectangle/RectangleConfig.json" = {
    # Note that Rectangle renames the file on startup (to avoid double loading).
    # We will be adding the file again on rebuild, so with time the folder will
    # be filled with more and more symlinks.
    source = ./rectangle/RectangleConfig.json;
  };

  # --- Scripts
  ".bin/release" = {
    source = ./bin/release;
    executable = true;
  };

  ".bin/clojars-release" = {
    source = ./bin/clojars-release;
    executable = true;
  };

  # --- Wezterm
  ".wezterm.lua" = {
    text = ''
      local wezterm = require 'wezterm'
      local mux = wezterm.mux
      local config = {}

      config.term = "wezterm"

      -- Maximize on Startup
      wezterm.on("gui-startup", function()
        local tab, pane, window = mux.spawn_window{}
        window:gui_window():maximize()
      end)

      -- Theme
      config.color_scheme = "${T.colorscheme.name}"
      config.font = wezterm.font "${T.font.fontFamily}"
      config.font_size = ${builtins.toString T.font.fontSize}

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

  ".config/wezterm/colors/everforest-dark.toml" = {
    source = ./wezterm/everforest-dark.toml;
  };

}
