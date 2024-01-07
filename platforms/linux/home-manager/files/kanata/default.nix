{ pkgs, userData, ... }:

{
  ".config/kanata/colemak-dh.kbd" = {
    source = ./colemak-dh.kbd;
  };

  ".config/kanata/kanata.service" = {
    text = ''
      [Unit]
      Description=Kanata Service

      [Service]
      ExecStartPre=/sbin/modprobe uinput
      ExecStart=${pkgs.kanata-custom}/bin/kanata -c ${./colemak-dh.kbd}
      Restart=no

      [Install]
      WantedBy=default.target
    '';
  };

  ".config/kanata/input.rules" = {
    text = ''
      KERNEL=="uinput", GROUP="uinput", MODE:="0660"
    '';
  };

  ".bin/setup-kanata" = {
    text = ''
      #!/bin/sh

      # we run this even though, before setting up permissions it will fail
      cp -f ${userData.home}/.config/kanata/kanata.service ${userData.home}/.config/systemd/user/kanata.service
      systemctl enable --user kanata.service

      # set up the groups and permissions for /dev/uinput
      set -e
      sudo groupadd -f uinput
      sudo usermod -aG uinput ${userData.user}
      sudo cp -f ${userData.home}/.config/kanata/input.rules /etc/udev/rules.d/99-input.rules

      # instruct to reboot
      echo "Please reboot your machine."
    '';
    executable = true;
  };
}


