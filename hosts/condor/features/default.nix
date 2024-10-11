_: let
  path = ./.;
  imports =
    builtins.map
    (n: (path + ("/" + n)))
    (builtins.filter
      (n:
        (n != "default.nix")
        && (builtins.match ".*\\.nix" n
          != null
          || builtins.pathExists (path + ("/" + n + "/default.nix"))))
      (builtins.attrNames (builtins.readDir path)));
in {
  inherit imports;
}
