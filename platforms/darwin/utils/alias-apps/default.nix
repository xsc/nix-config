{
  config,
  lib,
  pkgs,
  userData,
  ...
}: let
  user = userData.user;
  home = userData.home;
  mkalias = pkgs.writeScriptBin "mkalias" ''
    #!/usr/bin/env swift

    import Foundation

    var from: String? = CommandLine.arguments[1]
    var to: String? = CommandLine.arguments[2]
    let url = URL(fileURLWithPath: from!)
    let aliasUrl = URL(fileURLWithPath: to!)

    do {
        let data = try url.bookmarkData(
          options: .suitableForBookmarkFile,
          includingResourceValuesForKeys: nil,
          relativeTo: nil
        )
        try URL.writeBookmarkData(data, to: aliasUrl)
    } catch {
        print("Unexpected error: \(error).")
        exit(1)
    }
  '';
  mkAliasBin = "${mkalias}/bin/mkalias";

  sourcePath = "${config.system.build.applications}/Applications";
  targetPath = "${home}/Applications/Nix";
in {
  config = {
    system.activationScripts.postActivation.text = ''
      mkdir -p "${targetPath}"
      chown "${user}" "${targetPath}"

      find "${sourcePath}" -maxdepth 1 -type l | while read f; do
        src=$(readlink -f "$f")
        app=$(basename "$src")
        dest="${targetPath}/$app"

        echo "aliasing application: $app"
        ${mkAliasBin} "''${src}" "''${dest}"
      done
    '';
  };
}
