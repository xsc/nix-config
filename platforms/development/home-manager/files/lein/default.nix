{
  ageSecrets,
  config,
  ...
}: {
  home.file.".lein/profiles.clj" = {
    source = ./profiles.clj;
  };

  home.file.".lein/credentials.clj.gpg" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
      ageSecrets."credentials.clj.gpg".path;
  };
}
