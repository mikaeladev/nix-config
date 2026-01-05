{ config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  inherit (lib)
    mapAttrsToList
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.programs.thunderbird;

  oldConfigPath = 
    if isDarwin
    then "Library/Thunderbird"
    else ".thunderbird";

  newConfigPath = cfg.configPath;

  addId = value: builtins.map (
    a: a // { id = builtins.hashString "sha256" a.name; }
  ) value;

  getAccountsForProfile = profileName: accounts: builtins.filter (a:
    (a.thunderbird.profiles == [ ])
    || (lib.any (p: p == profileName) a.thunderbird.profiles)
  ) accounts;

  redirectFile = value: {
    "${oldConfigPath}/${value}".enable = false;
    "${newConfigPath}/${value}".text =
      config.home.file."${oldConfigPath}/${value}".text
    ;
  };

  redirectDirectory = value: {
    "${oldConfigPath}/${value}".enable = false;
    "${newConfigPath}/${value}" = {
      source = config.home.file."${oldConfigPath}/${value}".source;
      recursive = true;
      force = true;
    };
  };

  redirectFileIf = cond: value: mkIf cond (redirectFile value);
  redirectDirectoryIf = cond: value: mkIf cond (redirectDirectory value);
in

{
  options.programs.thunderbird.configPath = mkOption {
    type = types.str;
    default = oldConfigPath;
    description = ''
      The path to the Thunderbird config directory. This option does not
      change where Thunderbird looks for config files, only where generated
      files are placed. Only change if you have a nonstandard installation,
      such as when overriding $HOME in a wrapped package.
    '';
  };

  config.home.file = mkIf cfg.enable (
    mkMerge (
      [ (redirectFile "profiles.ini") ]
      ++ (mapAttrsToList (
        name: profile:

        let
          enabledEmailAccounts = builtins.filter
            (a: a.enable && a.thunderbird.enable)
            (builtins.attrValues config.accounts.email.accounts);

          enabledEmailAccountsWithId = addId enabledEmailAccounts;

          emailAccountsWithFilters = builtins.filter
            (a: a.thunderbird.messageFilters != [ ])
            (getAccountsForProfile name enabledEmailAccountsWithId);
        in

        mkMerge (
          [
            (redirectFile "${name}/user.js")
            (redirectFileIf (profile.userChrome != "") "${name}/userChrome.css")
            (redirectFileIf (profile.userContent != "") "${name}/userContent.css")
            (redirectFileIf (profile.search.enable) "${name}/search.json.mozlz4")
            (redirectDirectoryIf (profile.extensions != [ ]) "${name}/extensions")
          ]
          ++ (builtins.map
            (a: redirectFile "${name}/ImapMail/${a.id}/msgFilterRules.dat")
            emailAccountsWithFilters
          )
        )
      ) cfg.profiles)
    )
  );
}
