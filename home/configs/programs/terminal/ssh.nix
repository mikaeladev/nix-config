{ lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "auto-ssh-add" ''
      set -euo pipefail

      export PATH="${
        lib.makeBinPath [
          pkgs.expect
          pkgs.openssh
        ]
      }:$PATH"

      device=''${1:-secrets}

      device_dir="/run/media/$USER/$device"
      secrets_dir="$device_dir/ssh/passphrases"

      identities=(auth sign)

      if [ ! -d "$device_dir" ]; then
        echo "device not found: $device"
        exit 1
      fi

      if [ ! -d "$secrets_dir" ]; then
        echo "ssh secrets not found on device: $device"
        exit 1
      fi

      for identity in "''${identities[@]}"; do
        expect <<EOF
      spawn ssh-add "$HOME/.ssh/''${identity}_id_ed25519"
      expect "Enter passphrase"
      send "$(cat "$secrets_dir/$identity-ssh-passphrase.txt")\r"
      expect eof
      EOF
      done
    '')
  ];
}
