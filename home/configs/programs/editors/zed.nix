{ pkgs, ... }:

{
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

    extensions = [
      # languages
      "astro"
      "basher"
      "desktop"
      "git-firefly"
      "html"
      "ini"
      "log"
      "lua"
      "make"
      "neocmake"
      "nix"
      "qml"
      "scheme"
      "scss"
      "toml"
      "xml"

      # themes
      "one-dark-pro"
      "charmed-icons"

      # other bits
      "discord-presence"
    ];
  };
}
