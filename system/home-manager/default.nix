{ userData, theme, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    users.${userData.user} = { pkgs, config, lib, ... }: {
      inherit (import ./home.nix
        {
          inherit pkgs config lib userData theme;
        });
    };
  };
}
