{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    getName
    getVersion
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    types
    ;
  inherit (pkgs) runCommand symlinkJoin;

  cfg = config.programs.gram;

  extensionsDir =
    if pkgs.stdenv.isDarwin && !config.xdg.enable then
      "Library/Application Support/Gram/extensions/installed"
    else
      "${config.xdg.dataHome}/gram/extensions/installed";
in

{
  options.programs.gram = {
    enable = mkEnableOption "Gram";

    package = mkPackageOption pkgs "gram" { nullable = true; };

    extensionPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "with pkgs.zed-extensions; [ toml ]";
      description = ''
        List of extension packages to install.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "with pkgs; [ nil ]";
      description = ''
        List of extra packages to install.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = optional (cfg.package != null) (
      if cfg.extraPackages == [ ] then
        cfg.package
      else
        (symlinkJoin {
          pname = "${getName cfg.package}-wrapped";
          version = getVersion cfg.package;
          paths = [ cfg.package ];
          preferLocalBuild = true;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/${cfg.package.meta.mainProgram or "gram"} \
              --suffix PATH : ${lib.makeBinPath cfg.extraPackages}
          '';
        })
    );

    home.file.${extensionsDir} = {
      recursive = true;
      source = runCommand "gram-extensions" { } ''
        drvs=(${escapeShellArgs cfg.extensionPackages})
        paths=(/share/gram/extensions /share/zed/extensions)

        mkdir $out/

        for drv in "''${drvs[@]}"; do
          for path in "''${paths[@]}"; do
            if [ -e "$drv/$path" ]; then
              ln -s "$drv/$path"/* $out/
            fi
          done
        done
      '';
    };
  };
}
