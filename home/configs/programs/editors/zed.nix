{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    mutableUserSettings = false;
    mutableUserKeymaps = false;
    mutableUserTasks = false;

    userSettings = {
      base_keymap = "VSCode";

      soft_wrap = "editor_width";
      preferred_line_length = 80;
      tab_size = 2;

      format_on_save = "off";
      autosave.after_delay.milliseconds = 1000;

      theme = "One Dark Pro";
      icon_theme = "Base Charmed Icons";

      ui_font_family = "SF Pro";
      ui_font_weight = 400;
      ui_font_size = 16;

      buffer_font_family = "JetBrains Mono";
      buffer_font_weight = 400;
      buffer_font_size = 14;

      text_rendering_mode = "grayscale";

      agent.button = false;
      debugger.button = false;
      diagnostics.button = true;
      global_lsp_settings.button = true;
      search.button = true;

      outline_panel.button = false;
      collaboration_panel.button = false;

      project_panel = {
        button = true;
        hide_root = true;
        hide_hidden = false;
        sticky_scroll = true;
        auto_fold_dirs = false;
        auto_reveal_entries = true;
        sort_mode = "directories_first";
        sort_order = "upper";
        dock = "left";
      };

      git_panel = {
        button = true;
        sort_by_path = false;
        status_style = "icon";
        dock = "left";
      };

      title_bar = {
        show_menus = false;
        show_sign_in = false;
        show_user_menu = false;
        show_user_picture = false;
        show_branch_name = true;
        show_branch_status_icon = true;
        show_project_items = true;
        show_onboarding_banner = false;
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

      lsp = {
        vtsls.settings.autoUseWorkspaceTsdk = true;
        qml.binary.arguments = [ "-E" ];
      };

      disable_ai = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
    };

    extraPackages = with pkgs; [
      nil
      nixd
      shellcheck
    ];
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
