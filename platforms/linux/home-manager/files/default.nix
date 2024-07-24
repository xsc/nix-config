{ ... }:

{
  imports = [
    ./lein
    ./wezterm
  ];

  home.file = {
    ".bin/release" = {
      source = ./bin/release;
      executable = true;
    };

    ".bin/clojars-release" = {
      source = ./bin/clojars-release;
      executable = true;
    };
  };
}
