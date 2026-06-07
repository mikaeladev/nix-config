{
  config,
  globals,
  pkgs,
  ...
}:

let
  inherit (config.xdg) stateHome;
  inherit (config.lib.custom) wrapHome wrapStandaloneBin;
in

{
  home.packages = [
    (wrapHome {
      newHome = "${stateHome}/steam-home";
      package =
        if globals.standalone then wrapStandaloneBin "/usr/bin/steam" else pkgs.steam;
    })
  ];

  home.shellAliases = rec {
    # really useful for when plasmashell panels glitch out
    restart-plasma = "systemctl --user restart plasma-plasmashell";

    home-rebuild = "NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure";
    home-rollback = "${home-rebuild} --rollback";
  };
}
