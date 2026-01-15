{ config, pkgs-stable, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  programs.zed-editor = {
    enable = true;
    package = wrapGraphics pkgs-stable.zed-editor;
    
    extraPackages = [
      pkgs-stable.nil
      pkgs-stable.nixd
      pkgs-stable.shellcheck
    ];

    # immutable config files
    mutableUserSettings = false;
    mutableUserKeymaps = false;
    mutableUserTasks = false;

    userSettings = {
      # ui and theme
      ui_font_family = "SF Pro";
      ui_font_size = 16;
      buffer_font_family = "JetBrains Mono";
      buffer_font_size = 14;
      cursor_blink = true;
      terminal.blinking = "on";
      project_panel.auto_fold_dirs = false;
      minimap.show = "never";
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

      # file types and languages
      file_types = {
        json = [ "*.lsj" ];
        jsonc = [ "*.json" ];
        properties = [ ".env.*" ];
      };
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

    extensions = [
      "astro"
      "basher"
      "charmed-icons"
      "desktop"
      "discord-presence"
      "git-firefly"
      "html"
      "ini"
      "log"
      "neocmake"
      "nix"
      "one-dark-pro"
      "qml"
      "scheme"
      "toml"
      "xml"
    ];
  };
  
  
}
