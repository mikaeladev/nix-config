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
    isString
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    types
    ;
  inherit (pkgs) formats runCommand symlinkJoin;

  jsonFormat = formats.json { };

  cfg = config.programs.gram;

  dataDir =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/Gram"
    else
      (config.xdg.dataHome + "/gram");
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
        List of extra packages available to the binary.
      '';
    };

    settings = mkOption {
      type = with types; either (attrsOf jsonFormat.type) lines;
      default = { };
      example = {
        buffer_font_family = "JetBrains Mono";
        buffer_font_weight = 400;
        buffer_font_size = 14;
      };
      description = ''
        Configuration to write to {file}`settings.jsonc`.

        See the Gram [docs] for more information.

        [docs]: https://gram-editor.com/docs/configuring-gram/
      '';
    };

    keymaps = mkOption {
      type = with types; either (listOf jsonFormat.type) lines;
      default = [ ];
      example = [
        {
          bindings = {
            ctrl-right = "editor::SelectLargerSyntaxNode";
            ctrl-left = "editor::SelectSmallerSyntaxNode";
          };
        }
        {
          context = "ProjectPanel && not_editing";
          bindings = {
            "o" = "project_panel::Open";
          };
        }
      ];
      description = ''
        List of key bindings to write to {file}`keymap.jsonc`.

        See the Gram [docs] for more information.

        [docs]: https://gram-editor.com/docs/key-bindings/
      '';
    };

    debugger = mkOption {
      type = with types; either (listOf jsonFormat.type) lines;
      default = [ ];
      example = [
        {
          label = "Example Start debugger config";
          adapter = "Example adapter name";
          request = "launch";
          program = "path_to_program";
          cwd = "$GRAM_WORKTREE_ROOT";
        }
      ];
      description = ''
        List of debug configurations to write to {file}`debug.jsonc`.

        See the Gram [docs] for more information.

        [docs]: https://gram-editor.com/docs/debugger/
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.extraPackages != [ ] -> cfg.package != null;
        message = ''
          The `programs.gram.extraPackages` option requires that `programs.gram.package`
          not be null in order to be applied.
        '';
      }
    ];

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

    xdg.configFile = {
      "gram/settings.jsonc" = mkIf (cfg.settings != { }) (
        if isString cfg.settings then
          { text = cfg.settings; }
        else
          { source = jsonFormat.generate "settings.jsonc" cfg.settings; }
      );
      "gram/keymap.jsonc" = mkIf (cfg.keymaps != [ ]) (
        if isString cfg.keymaps then
          { text = cfg.keymaps; }
        else
          { source = jsonFormat.generate "keymap.jsonc" cfg.keymaps; }
      );
      "gram/debug.jsonc" = mkIf (cfg.debugger != [ ]) (
        if isString cfg.debugger then
          { text = cfg.debugger; }
        else
          { source = jsonFormat.generate "debug.jsonc" cfg.debugger; }
      );
    };

    home.file."${dataDir}/extensions/installed" = {
      recursive = true;
      source = runCommand "gram-extensions" { } ''
        set -euo pipefail

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
