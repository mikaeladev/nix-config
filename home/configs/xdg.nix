{ config, globals, ... }:

let
  mimeApps = {
    aseprite = "aseprite.desktop";
    deadlock-mod-manager = ".deadlock-mod-manager-wrapped-handler.desktop";
    dolphin = "org.kde.dolphin.desktop";
    gwenview = "org.kde.gwenview.desktop";
    kwrite = "org.kde.kwrite.desktop";
    vesktop = "vesktop.desktop";
    zed-editor = "dev.zed.Zed.desktop";
    zen-browser = "app.zen_browser.zen.desktop";
  };

  mimeGroups = {
    imageFile = with mimeApps; [
      gwenview
      aseprite
    ];
    plainText = with mimeApps; [
      kwrite
      zed-editor
    ];
    srcCode = with mimeApps; [
      zed-editor
      kwrite
    ];
    webFile = with mimeApps; [
      zed-editor
      zen-browser
      kwrite
    ];
  };

  addedMimeAssociations = {
    "x-scheme-handler/deadlock-mod-manager" = mimeApps.deadlock-mod-manager;
    "x-scheme-handler/discord" = mimeApps.vesktop;
    "x-scheme-handler/zed" = mimeApps.zed-editor;
  };

  defaultApplications = addedMimeAssociations // {
    "inode/directory" = [
      mimeApps.dolphin
      mimeApps.zed-editor
    ];

    "image/png" = mimeGroups.imageFile;
    "image/webp" = mimeGroups.imageFile;

    "application/x-zerosize" = mimeGroups.plainText;
    "text/*" = mimeGroups.plainText;

    "application/x-docbook+xml" = mimeGroups.srcCode;
    "application/x-shellscript" = mimeGroups.srcCode;
    "application/x-yaml" = mimeGroups.srcCode;
    "text/csv" = mimeGroups.srcCode;
    "text/markdown" = mimeGroups.srcCode;
    "text/x-c++hdr" = mimeGroups.srcCode;
    "text/x-c++src" = mimeGroups.srcCode;
    "text/x-chdr" = mimeGroups.srcCode;
    "text/x-cmake" = mimeGroups.srcCode;
    "text/x-csharp" = mimeGroups.srcCode;
    "text/x-csrc" = mimeGroups.srcCode;
    "text/x-go" = mimeGroups.srcCode;
    "text/x-java" = mimeGroups.srcCode;
    "text/x-lua" = mimeGroups.srcCode;
    "text/x-python" = mimeGroups.srcCode;
    "text/x-qml" = mimeGroups.srcCode;

    "application/json" = mimeGroups.webFile;
    "application/xml" = mimeGroups.webFile;
    "text/css" = mimeGroups.webFile;
    "text/javascript" = mimeGroups.webFile;
    "text/html" = mimeGroups.webFile;
  };
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
      enable = true;

      associations.added = addedMimeAssociations;
      defaultApplications = defaultApplications;

      defaultApplicationPackages = with config.programs; [
        kitty.package
        prismlauncher.package
        spicetify.spicedSpotify
        zapzap.package
      ];
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
