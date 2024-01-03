{ pkgs }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  user = if isDarwin then "yannick.scherer" else "yannick";
  home = if isDarwin then "/Users/${user}" else "/home/${user}";
in
{
  inherit user home;
  name = "Yannick Scherer";
  email = "yannick@xsc.dev";
  signingKey = "FCC8CDA4";
}
