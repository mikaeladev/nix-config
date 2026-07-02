{
  programs.nixvim.plugins = {
    nix.enable = true;

    bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        color_icons = true;
        show_buffer_icons = true;
        show_buffer_close_icons = true;
        show_tab_indicators = true;
        show_duplicate_prefix = true;
        persist_buffer_sort = true;

        offsets = [
          {
            text = "File Tree";
            filetype = "neo-tree";
            separator = true;
            text_align = "left";
          }
        ];
      };
    };

    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;

        enable_diagnostics = true;
        enable_git_status = true;
        enable_modified_markers = true;
        enable_refresh_on_write = true;

        popup_border_style = "single";

        buffers = {
          bind_to_cwd = false;
          follow_current_file.enabled = true;
        };
      };
    };

    illuminate = {
      enable = true;
      settings = {
        under_cursor = true;
      };
    };

    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
      };
    };
  };
}
