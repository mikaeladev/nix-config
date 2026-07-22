{ config, lib, ... }:

let
  inherit (lib) mkIf;
in

{
  config = mkIf config.globals.storage.enable {
    programs.zen-browser = {
      enable = true;
      profiles = { };
    };

    xdg.configFile =
      let
        profilesDir = config.globals.storage.mountPoint + "/zen/profiles";

        homeProfile = profilesDir + "/home";
        privateProfile = profilesDir + "/private";
      in
      {
        "zen/profiles.ini".text = ''
          [Profile1]
          IsRelative=0
          Name=private
          Path=${privateProfile}

          [Profile0]
          IsRelative=0
          Name=home
          Path=${homeProfile}
          Default=1

          [General]
          StartWithLastProfile=1
          Version=2

          [Install0]
          Default=${homeProfile}
          Locked=1
        '';

        "zen/installs.ini".text = ''
          [0]
          Default=${homeProfile}
          Locked=1
        '';
      };
  };
}
