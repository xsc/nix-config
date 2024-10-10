{
  imports = [
    ./lein
    ./wezterm
  ];

  home.file.".bin/release" = {
    source = ./bin/release;
    executable = true;
  };

  home.file.".bin/clojars-release" = {
    source = ./bin/clojars-release;
    executable = true;
  };
}
