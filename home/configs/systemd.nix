{ config, ... }:

let
  environment = {
    XDG_CACHE_HOME = config.xdg.cacheHome;
    XDG_CONFIG_HOME = config.xdg.configHome;
    XDG_DATA_HOME = config.xdg.dataHome;
    XDG_STATE_HOME = config.xdg.stateHome;
  };
in

{
  systemd.user.settings.Manager = {
    ManagerEnvironment = environment;
    DefaultEnvironment = environment;
  };
}
