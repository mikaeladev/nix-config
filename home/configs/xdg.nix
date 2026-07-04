{
  config,
  globals,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mapAttrs;

  withExt = value: value + ".desktop";
  withExtAttrs = attrs: mapAttrs (_: value: withExt value) attrs;

  mimeApps = withExtAttrs {
    aseprite = "aseprite";
    dolphin = "org.kde.dolphin";
    gwenview = "org.kde.gwenview";
    kwrite = "org.kde.kwrite";
    zed-editor = "dev.zed.Zed";
    zen-browser = "zen-beta";
  };

  mimeAppsByFunction = rec {
    textEditor = [ mimeApps.kwrite ];
    codeEditor = [ mimeApps.zed-editor ] ++ textEditor;
    bitmapEditor = [ mimeApps.aseprite ];
    webBrowser = [ mimeApps.zen-browser ];
    fileBrowser = [ mimeApps.dolphin ] ++ codeEditor;
    imageViewer = [ mimeApps.gwenview ];
  };

  inherit (config.home) homeDirectory;

  baseDirectories = mapAttrs (
    _: value: "${homeDirectory}/${value}"
  ) globals.xdgBaseDirectoryParts;

  inherit (baseDirectories)
    cacheHome
    configHome
    dataHome
    stateHome
    ;
in

{
  xdg = {
    enable = true;
    autostart.enable = true;
    mime.enable = true;

    mimeApps = rec {
      enable = true;

      associations.added = {
        "x-scheme-handler/discord" = withExt "vesktop";
        "x-scheme-handler/zed" = mimeApps.zed-editor;
      };

      defaultApplications =
        associations.added
        // (with mimeAppsByFunction; {
          "inode/directory" = fileBrowser;

          "text/*" = textEditor;
          "text/csv" = textEditor;
          "text/markdown" = textEditor;
          "application/xml" = textEditor;
          "application/json" = textEditor;
          "application/x-yaml" = textEditor;
          "application/x-shellscript" = textEditor;
          "application/x-zerosize" = textEditor;

          "text/css" = codeEditor;
          "text/javascript" = codeEditor;
          "text/x-c++hdr" = codeEditor;
          "text/x-c++src" = codeEditor;
          "text/x-chdr" = codeEditor;
          "text/x-cmake" = codeEditor;
          "text/x-csharp" = codeEditor;
          "text/x-csrc" = codeEditor;
          "text/x-go" = codeEditor;
          "text/x-java" = codeEditor;
          "text/x-lua" = codeEditor;
          "text/x-python" = codeEditor;
          "text/x-qml" = codeEditor;

          "image/png" = imageViewer ++ bitmapEditor;
          "image/svg+xml" = imageViewer ++ textEditor;

          "text/html" = webBrowser ++ codeEditor;
        });

      defaultApplicationPackages = [
        pkgs.kdePackages.ark
        pkgs.kdePackages.gwenview
        config.programs.kitty.package
        config.programs.krita.package
        config.programs.prismlauncher.package
        config.programs.spicetify.spicedSpotify
      ];
    };

    inherit
      cacheHome
      configHome
      dataHome
      stateHome
      ;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;

      desktop = "${homeDirectory}/desktop";
      download = "${homeDirectory}/downloads";
      projects = "${homeDirectory}/projects";
      documents = "${homeDirectory}/documents";

      templates = "${homeDirectory}/documents/templates";
      publicShare = "${homeDirectory}/documents/public";

      pictures = "${homeDirectory}/media/pictures";
      videos = "${homeDirectory}/media/videos";
      music = "${homeDirectory}/media/music";
    };
  };

  home.preferXdgDirectories = true;

  home.sessionVariables = {
    CUDA_CACHE_PATH = "${cacheHome}/nvidia";
    GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";
    FFMPEG_DATADIR = "${dataHome}/ffmpeg";
    WINEPREFIX = "${dataHome}/wineprefixes/default";
    BUN_INSTALL = "${dataHome}/bun";
    CARGO_HOME = "${dataHome}/cargo";
    RUSTUP_HOME = "${dataHome}/rustup";
  };
}
