{ pkgs, ... }:

{
  programs.gram = {
    enable = true;

    settings = {
      theme = "One Dark Pro";
      icon_theme = "Base Charmed Icons";

      ui_font_family = "SF Pro";
      ui_font_weight = 400;
      ui_font_size = 14;

      buffer_font_family = "JetBrains Mono";
      buffer_font_weight = 400;
      buffer_font_size = 14;

      text_rendering_mode = "grayscale";

      base_keymap = "VSCode";

      restore_on_startup = "last_workspace";
      when_closing_with_no_tabs = "close_window";

      soft_wrap = "editor_width";
      preferred_line_length = 80;
      tab_size = 2;

      format_on_save = "off";
      autosave.after_delay.milliseconds = 1000;

      debugger.button = false;
      diagnostics.button = true;
      global_lsp_settings.button = true;
      search.button = true;

      project_panel = {
        button = true;
        dock = "left";
        entry_spacing = "comfortable";
        file_icons = true;
        folder_icons = true;
        git_status = true;
        indent_size = 20;
        auto_fold_dirs = false;
        auto_reveal_entries = true;
        hide_hidden = false;
        hide_root = true;
        sort_mode = "directories_first";
        sort_order = "upper";
        starts_open = true;
        sticky_scroll = true;
      };

      git_panel = {
        button = true;
        dock = "left";
        status_style = "icon";
        sort_by_path = false;
      };

      outline_panel.button = false;

      title_bar = {
        show_branch_name = true;
        show_branch_status_icon = true;
        show_project_items = true;
        show_onboarding_banner = false;
        show_user_picture = false;
        show_menus = false;
      };

      tab_bar = {
        show = true;
        show_tab_bar_buttons = false;
        show_nav_history_buttons = false;
      };

      status_bar = {
        active_language_button = true;
        cursor_position_button = true;
        line_endings_button = false;
        active_encoding_button = "non_utf8";
      };

      tabs = {
        git_status = true;
        file_icons = true;
        show_close_button = "hover";
        show_diagnostics = "all";
      };

      terminal = {
        button = true;
        blinking = "on";
        cursor_shape = "block";
        font_family = "JetBrainsMono Nerd Font";
        font_weight = 400;
        font_size = 14;
      };

      gutter = {
        min_line_number_digits = 4;
        line_numbers = true;
        runnables = false;
        breakpoints = false;
        folds = false;
      };

      scrollbar = {
        show = "auto";
        diagnostics = "all";
        cursors = true;
        git_diff = true;
        search_results = true;
        selected_text = true;
        selected_symbol = true;
      };

      minimap.show = "never";

      file_types = {
        json = [ "*.lsj" ];
        jsonc = [ "*.json" ];
        properties = [ ".env.*" ];
      };

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external = {
            command = "nix";
            arguments = [
              "fmt"
              "--"
              "--stdin"
              "{buffer_path}"
            ];
          };
        };
      };
    };

    extensionPackages = with pkgs.zed-extensions; [
      # languages
      desktop
      git-firefly
      ini
      log
      make
      neocmake
      qml
      rasi
      scheme
      scss
      tombi
      toml
      xml
      yuck

      # themes
      charmed-icons
      one-dark-pro

      # other bits
      discord-presence
    ];

    extraPackages = with pkgs; [
      nixd
      shellcheck
    ];
  };
}
