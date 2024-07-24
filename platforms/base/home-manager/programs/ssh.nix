{ ... }:

{
  ssh = {
    enable = true;

    extraConfig = ''
      Include config.d/ssh_config
    '';
  };
}
