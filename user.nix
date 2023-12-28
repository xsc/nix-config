{}:

rec {
  name = "Yannick Scherer";
  user = "yannick";
  email = "yannick@xsc.dev";
  signingKey = "FCC8CDA4";

  homeDirectory = pkgs:
    if pkgs.stdenv.isDarwin
    then "/Users/${user}"
    else "/home/${user}";
}
