{pkgs, ...}: {
  home-manager.sharedModules = [
    {
      systemd.user.services.ulauncher = {
        Unit = {
          Description = "Linux Application Launcher";
          Documentation = ["https://ulauncher.io/"];
        };

        Service = {
          Type = "simple";
          Restart = "always";
          RestartSec = 1;
          ExecStart = pkgs.writeShellScript "ulauncher-env-wrapper.sh" ''
            export PATH="''${XDG_BIN_HOME}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
            export GDK_BACKEND=x11
            exec ${pkgs.ulauncher}/bin/ulauncher --hide-window
          '';
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };
    }
  ];
}
