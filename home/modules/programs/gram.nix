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
    hasSuffix
    isString
    literalExpression
    mapAttrs'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    nameValuePair
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

    # packages #

    package = mkPackageOption pkgs "gram" { nullable = true; };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "with pkgs; [ nil ]";
      description = ''
        List of extra packages available to Gram.
      '';
    };

    extensionPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "with gram-extensions; [ catppuccin ]";
      description = ''
        List of extension packages to install.

        See also:
        - <https://codeberg.org/niklaskorz/nix-gram-extensions>
        - <https://github.com/DuskSystems/nix-zed-extensions>
      '';
    };

    # single-file configs #

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
        List of [debug tasks] to write to {file}`debug.jsonc`.

        [debug tasks]: https://gram-editor.com/docs/debugger/
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
          bindings.o = "project_panel::Open";
        }
      ];
      description = ''
        List of [key bindings] to write to {file}`keymap.jsonc`.

        [key bindings]: https://gram-editor.com/docs/key-bindings/
      '';
    };

    tasks = mkOption {
      type = with types; either (listOf jsonFormat.type) lines;
      default = [ ];
      example = [
        {
          label = "Example task";
          command = "for i in {1..5}; do echo \"Hello $i/5\"; sleep 1; done";
          env.foo = "bar";
          use_new_terminal = false;
          allow_concurrent_runs = false;
          reveal = "always";
          hide = "never";
          shell = "system";
          show_summary = true;
          show_command = true;
          save = "none";
        }
      ];
      description = ''
        List of [tasks] to write to {file}`tasks.jsonc`.

        [tasks]: https://gram-editor.com/docs/tasks/
      '';
    };

    # multi-file configs #

    snippets = mkOption {
      type = with types; attrsOf (either (attrsOf jsonFormat.type) lines);
      default = { };
      example = {
        javascript = {
          "Log to console" = {
            prefix = "log";
            description = "Logs to console";
            body = [
              "console.info(\"Hello, \${1:World}!\")"
              "$0"
            ];
          };
        };
      };
      description = ''
        Set of [snippets] to write to {file}`snippets/‹name›.json`.

        [snippets]: https://gram-editor.com/docs/snippets/
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.extraPackages != [ ] -> cfg.package != null;
        message = ''
          The `programs.gram.extraPackages` option requires that `programs.gram.package`
          not be null.
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

    xdg.configFile =
      let
        mkFileAttrs =
          name: value:
          if isString value then
            { text = value; }
          else
            { source = jsonFormat.generate name value; };

        withSuffix =
          suffix: value: if (hasSuffix suffix value) then value else (value + suffix);
      in
      {
        "gram/settings.jsonc" = mkIf (cfg.settings != { }) (
          mkFileAttrs "settings.jsonc" cfg.settings
        );
        "gram/debug.jsonc" = mkIf (cfg.debugger != [ ]) (
          mkFileAttrs "debug.jsonc" cfg.debugger
        );
        "gram/keymap.jsonc" = mkIf (cfg.keymaps != [ ]) (
          mkFileAttrs "keymap.jsonc" cfg.keymaps
        );
        "gram/tasks.jsonc" = mkIf (cfg.tasks != [ ]) (
          mkFileAttrs "tasks.jsonc" cfg.tasks
        );
      }
      // (mapAttrs' (
        name: value:
        let
          suffixedName = withSuffix ".json" name;
        in
        nameValuePair ("gram/snippets/" + suffixedName) (mkFileAttrs suffixedName value)
      ) cfg.snippets);

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
