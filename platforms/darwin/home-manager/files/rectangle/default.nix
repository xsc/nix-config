{
  home.file = {
    "Library/Application Support/Rectangle/RectangleConfig.json" = {
      # Note that Rectangle renames the file on startup (to avoid double loading).
      # We will be adding the file again on rebuild, so with time the folder will
      # be filled with more and more symlinks.
      source = ./RectangleConfig.json;
    };
  };
}
