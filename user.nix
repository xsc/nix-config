{ pkgs }:

rec {
  name = "Yannick Scherer";
  user = "yannick.scherer";
  group = "staff";
  email = "yannick@xsc.dev";
  signingKey = "FCC8CDA4";

  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${user}"
    else "/home/${user}";
}
