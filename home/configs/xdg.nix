{
  config,
  globals,
  lib,
  ...
}:

let
  inherit (lib) mapAttrs;

  withExtension =
    extension: attrs: mapAttrs (_: value: value + ".${extension}") attrs;

  mimeApps = withExtension "desktop" {
    # kde apps (system-wide)
    ark = "org.kde.ark";
    dolphin = "org.kde.dolphin";
    gwenview = "org.kde.gwenview";
    kwrite = "org.kde.kwrite";
    # user apps (see programs dir)
    aseprite = "aseprite";
    deadlock-mod-manager = "Deadlock Mod Manager";
    prismlauncher = "org.prismlauncher.PrismLauncher";
    vesktop = "vesktop";
    zed-editor = "dev.zed.Zed";
    zen-browser = "zen-beta";
  };

  mimeGroups = with mimeApps; rec {
    plainText = [
      kwrite
      zed-editor
    ];
    rasterImageFile = [
      gwenview
      aseprite
    ];
    srcCode = [
      zed-editor
      kwrite
    ];
    srcCodeWeb = [
      zed-editor
      zen-browser
      kwrite
    ];
    vectorImageFile = [ gwenview ] ++ srcCodeWeb;
  };

  associations = {
    added = with mimeApps; {
      "x-scheme-handler/deadlock-mod-manager" = deadlock-mod-manager;
      "x-scheme-handler/discord" = vesktop;
      "x-scheme-handler/zed" = zed-editor;
      "x-scheme-handler/curseforge" = prismlauncher;
      "x-scheme-handler/prismlauncher" = prismlauncher;
    };
  };

  defaultApplications =
    associations.added
    // (with mimeGroups; {
      "inode/directory" = with mimeApps; [
        dolphin
        zed-editor
      ];

      "application/x-zerosize" = plainText;
      "text/*" = plainText;

      "image/png" = rasterImageFile;
      "image/webp" = rasterImageFile;
      "image/svg+xml" = vectorImageFile;

      "application/x-docbook+xml" = srcCode;
      "application/x-shellscript" = srcCode;
      "application/x-yaml" = srcCode;
      "text/csv" = srcCode;
      "text/markdown" = srcCode;
      "text/x-c++hdr" = srcCode;
      "text/x-c++src" = srcCode;
      "text/x-chdr" = srcCode;
      "text/x-cmake" = srcCode;
      "text/x-csharp" = srcCode;
      "text/x-csrc" = srcCode;
      "text/x-go" = srcCode;
      "text/x-java" = srcCode;
      "text/x-lua" = srcCode;
      "text/x-python" = srcCode;
      "text/x-qml" = srcCode;

      "application/json" = srcCodeWeb;
      "application/xml" = srcCodeWeb;
      "text/css" = srcCodeWeb;
      "text/javascript" = srcCodeWeb;
      "text/html" = srcCodeWeb;
    });

  defaultApplicationPackages = with config.programs; [
    kitty.package
    spicetify.spicedSpotify
    zapzap.package
  ];
in

{
  xdg = {
    inherit (globals.mainuser.xdg)
      cacheHome
      configHome
      dataHome
      stateHome
      ;

    enable = true;
    autostart.enable = true;
    mime.enable = true;

    mimeApps = {
      inherit associations defaultApplications defaultApplicationPackages;

      enable = true;
    };

    userDirs = with config.home; {
      enable = true;
      createDirectories = true;

      desktop = "${homeDirectory}/desktop";
      download = "${homeDirectory}/downloads";

      documents = "${homeDirectory}/documents";
      templates = "${homeDirectory}/documents/templates";
      publicShare = "${homeDirectory}/documents/public";

      pictures = "${homeDirectory}/media/pictures";
      videos = "${homeDirectory}/media/videos";
      music = "${homeDirectory}/media/music";
    };
  };

  home.sessionVariables = with config.xdg; {
    CUDA_CACHE_PATH = "${cacheHome}/nvidia";
    DOCKER_CONFIG = "${configHome}/docker";
    FFMPEG_DATADIR = "${configHome}/ffmpeg";
    GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";
    WINEPREFIX = "${dataHome}/wineprefixes/default";
    CARGO_HOME = "${dataHome}/cargo";
    RUSTUP_HOME = "${dataHome}/rustup";
    BUN_INSTALL = "${dataHome}/bun";
  };
}
