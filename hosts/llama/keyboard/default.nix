{ ... }:

{
  imports = [
    ./kanata.nix
  ];

  services.xserver.xkb.layout = "eu,de";
  console.keyMap = "us";
}
