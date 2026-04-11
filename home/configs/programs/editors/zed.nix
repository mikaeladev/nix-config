{ inputs, pkgs, ... }:

{
  imports = [ inputs.zed-extensions.homeManagerModules.default ];

  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      nil
      nixd
      shellcheck
    ];

    # immutable config files
    mutableUserSettings = false;
    mutableUserKeymaps = false;
    mutableUserTasks = false;

    userSettings = {
      # text rendering
      ui_font_family = "SF Pro";
      ui_font_size = 16;
      buffer_font_family = "JetBrains Mono";
      buffer_font_size = 14;
      text_rendering_mode = "grayscale";

      # ui & theme
      cursor_blink = true;
      terminal.blinking = "on";
      minimap.show = "never";
      project_panel.auto_fold_dirs = false;
      icon_theme = "Base Charmed Icons";
      theme = {
        mode = "dark";
        light = "One Light";
        dark = "One Dark Pro";
      };

      # editor behaviour
      base_keymap = "VSCode";
      soft_wrap = "editor_width";
      format_on_save = "off";
      autosave.after_delay.milliseconds = 1000;
      preferred_line_length = 80;
      linked_edits = true;
      tab_size = 2;

      # file associations
      file_types = {
        json = [ "*.lsj" ];
        jsonc = [ "*.json" ];
        properties = [ ".env.*" ];
      };

      # language servers
      lsp = {
        vtsls.settings.autoUseWorkspaceTsdk = true;
        qml.binary.arguments = [ "-E" ];
      };

      # ew
      disable_ai = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };
  };

  programs.zed-editor-extensions = {
    enable = true;
    packages = with pkgs.zed-extensions; [
      # languages
      astro
      basher
      desktop
      git-firefly
      html
      ini
      log
      lua
      make
      neocmake
      nix
      qml
      scheme
      scss
      tombi
      toml
      xml
      yuck

      # themes
      one-dark-pro
      charmed-icons

      # other bits
      discord-presence

      (pkgs.buildZedExtension (finalAttrs: {
        name = "rasi";
        version = "83f5e3befc28a7a4526648ff6a047a381132739b";

        src = pkgs.fetchFromGitHub {
          owner = "mikaeladev";
          repo = "zed-rasi";
          rev = finalAttrs.version;
          hash = "sha256-eQpLcRnu4hXLKNw9rlYV7ClVz1aiftXQhJAHukrjf+g=";
        };

        grammars = [
          (pkgs.buildZedGrammar (finalAttrs: {
            name = "rasi";
            version = "e735c6881d8b475aaa4ef8f0a2bdfd825b438143";

            src = pkgs.fetchFromGitHub {
              owner = "Fymyte";
              repo = "tree-sitter-rasi";
              rev = finalAttrs.version;
              hash = "sha256-MERNUroM1ndV6TtXYGg0AmXRtNlNWphVx32TzgMUnac=";
            };
          }))
        ];
      }))
    ];
  };
}
