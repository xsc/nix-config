{
  description = "Update immich's docker-compose.nix";

  inputs = {
    compose2nix.url = "github:aksiksi/compose2nix";
    compose2nix.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { compose2nix, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        defaultPackage = packages.update-docker-compose;
        packages.update-docker-compose =
          let
            pkgs = import nixpkgs { inherit system; };
            c2n = compose2nix.packages.${system}.default;
            name = "update-docker-compose";
            script = pkgs.writeShellScriptBin name ''
              set -eu

              VERSION=$1
              TARGET=$2

              URL=https://github.com/immich-app/immich/releases/download/$VERSION/docker-compose.yml
              TMP=''$(mktemp -d)
              INFILE="$TMP/docker-compose.yml"
              OUTFILE="$TMP/docker-compose.nix"

              # Fetch original docker-compose.yml
              ${pkgs.wget}/bin/wget -O "$INFILE" "$URL"

              # Initialize .env
              touch $TMP/.env

              # DB_PASSWORD is supplied by our secrets file
              ${pkgs.gnused}/bin/sed -i '/DB_PASSWORD/d' "$INFILE"

              # We want to listen on localhost
              ${pkgs.gnused}/bin/sed -i "s/2283:3001/127.0.0.1:2283:3001/" "$INFILE"

              # We don't need localtime because we set the TZ directly
              ${pkgs.gnused}/bin/sed -i '/localtime:ro/d' "$INFILE"

              # Generate and source .env
              echo "TZ=Etc/UTC" >> $TMP/.env
              echo "DB_USERNAME=postgres" >> $TMP/.env
              echo "DB_DATABASE_NAME=immich" >> $TMP/.env
              source $TMP/.env

              # Substitute these values directly
              export IMMICH_VERSION="$VERSION"
              export DATA_DIR="/var/immich"
              export DB_DATA_LOCATION="$DATA_DIR/postgres"
              export UPLOAD_LOCATION="$DATA_DIR/library"
              export DB_USERNAME
              export DB_DATABASE_NAME

              # Convert
              pushd "$TMP"
              ${c2n}/bin/compose2nix -project=immich \
                -write_nix_setup=false \
                -runtime docker \
                -inputs "$INFILE" \
                -output "$OUTFILE"
              popd

              # Inject secret env file
              ${pkgs.gnused}/bin/sed -i 's/pkgs, lib/config, pkgs, lib/' "$OUTFILE"
              ${pkgs.gnused}/bin/sed -i -E '/image =.+(immich|pg)/a \
                  environmentFiles = [ config.age.secrets."immich.env".path ];' \
                "$OUTFILE"

              # Run with immich user
              ${pkgs.gnused}/bin/sed -i '/serviceConfig =/a \
                    User = "immich";\
                    Group = "immich";' \
                "$OUTFILE"

              # Move
              mv "$OUTFILE" "$TARGET"
            '';
          in
          pkgs.symlinkJoin
            {
              name = name;
              paths = [ script ];
              buildInputs = [ ];
            };
      });
}





