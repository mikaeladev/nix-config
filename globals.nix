{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
in

{
  options.globals = {
    secrets = mkEnableOption "age-encrypted secrets";
    standalone = mkEnableOption "generic-linux configurations";

    mainuser = {
      nickname = mkOption {
        type = types.str;
        default = "maevis";
        description = "The mainuser's nickname.";
      };
      username = mkOption {
        type = types.str;
        default = "mainuser";
        description = "The mainuser's username.";
      };
      homeDirectory = mkOption {
        type = types.str;
        default = "/home/" + config.globals.mainuser.username;
        defaultText = "/home/\${config.globals.mainuser.username}";
        description = "The mainuser's username.";
      };
    };

    storage = {
      enable = mkEnableOption "storage configuarions";

      uuid = mkOption {
        type = types.str;
        default = "";
        description = "UUID of the storage device.";
      };
      mountPoint = mkOption {
        type = types.str;
        default = config.globals.mainuser.homeDirectory + "/storage";
        defaultText = "\${config.globals.mainuser.homeDirectory}/storage";
        description = "Path to mount the storage device on.";
      };
    };

    xdg = {
      configHome = mkOption {
        type = types.str;
        default = ".local/etc";
        description = "Path to the config directory relative to `$HOME`.";
      };
      dataHome = mkOption {
        type = types.str;
        default = ".local/share";
        description = "Path to the data directory relative to `$HOME`.";
      };
      cacheHome = mkOption {
        type = types.str;
        default = ".local/var/cache";
        description = "Path to the cache directory relative to `$HOME`.";
      };
      stateHome = mkOption {
        type = types.str;
        default = ".local/var/state";
        description = "Path to the state directory relative to `$HOME`.";
      };
    };
  };
}
