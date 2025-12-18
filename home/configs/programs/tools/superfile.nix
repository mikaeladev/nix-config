{ config, ... }:

let
  zoxideCfg = config.programs.zoxide;
in

{
  programs.superfile = {
    enable = true;
    zoxidePackage = zoxideCfg.package;

    settings = {
      theme = "rose-pine";
      default_directory = "~";
      auto_check_update = false;
      case_sensitive_sort = true;
      default_open_file_preview = false;
      file_size_use_si = true;
      ignore_missing_fields = true;
      sidebar_width = 0;
      show_image_preview = false;
      show_panel_footer_info = true;
      zoxide_support = zoxideCfg.enable;
    };
  };
}
