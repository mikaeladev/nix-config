inputs: pkgs: _:

let
  system = pkgs.stdenv.hostPlatform.system;
in

{
  apple-emoji = pkgs.callPackage (
    { stdenv, fetchurl, ... }:

    stdenv.mkDerivation (finalAttrs: {
      pname = "apple-emoji-ttf";
      version = "26.2.1";

      src = fetchurl {
        url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v${finalAttrs.version}/AppleColorEmoji.ttf";
        sha256 = "0g84h4xk7hvy9bsfvy15sx2s7plfx2qnqqpm686vb6idh6cgkdg7";
      };

      dontUnpack = true;

      installPhase = ''
        runHook preInstall
        install -Dm644 "$src" "$out/share/fonts/truetype/AppleColorEmoji.ttf"
        runHook postInstall
      '';
    })
  ) { };

  apple-sf-pro = pkgs.callPackage (
    { stdenv, fetchFromGitHub, ... }:

    stdenv.mkDerivation {
      pname = "apple-sf-pro";
      version = "1.0.0";

      src = fetchFromGitHub {
        owner = "sahibjotsaggu";
        repo = "San-Francisco-Pro-Fonts";
        rev = "8bfea09aa6f1139479f80358b2e1e5c6dc991a58";
        hash = "sha256-mAXExj8n8gFHq19HfGy4UOJYKVGPYgarGd/04kUIqX4=";
      };

      installPhase = ''
        runHook preInstall
        install -Dm644 -t "$out/share/fonts/truetype" *.ttf
        install -Dm644 -t "$out/share/fonts/opentype" *.otf
        runHook postInstall
      '';
    }
  ) { };

  zayron-simple-separator = pkgs.callPackage (
    { stdenv, fetchzip }:

    stdenv.mkDerivation {
      pname = "zayron-simple-separator";
      version = "1.4.7";

      src = fetchzip {
        # this does NOT feel reliable but it's worth a try
        # src: https://api.kde-look.org/ocs/v1/content/data/2137418
        url = "https://files06.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTc3NDM3MDY5OSwibyI6IjEiLCJzIjoiYjAyNTg3M2RjZDI4ZWM0NzYwNTUyNzczMDNkNjFlMmQ5NTZiOTgzMjY0Yzg2MTQxZmZmOGU5ZWVlYjA0MjNhN2VkODRhNWUzNTc1MThhMWVhZjY5NTVkNjM0ZDc0ZWM5ZDEyODY4MTExZjliMDU3ZTUwNTBlNjBiMzA1ZDY4ZmYiLCJ0IjoxNzgxMTYxMzQxLCJzdGZwIjpudWxsLCJzdGlwIjoiODIuNDMuMTAyLjEwOCJ9.crn7zfQ2DL8sSAaHOeI945_kd0rGAs-JsRgC9CA-nWw/zayron.simple.separator.tar.xz";
        hash = "sha256-NWTmLxCmAVF0IMX5ejZtQLKpWjAGffxTP2FYcrmVS3g=";
      };

      installPhase = ''
        runHook preInstall
        mkdir -p "$out/share/plasma/plasmoids"
        cp -r "$src/" "$out/share/plasma/plasmoids/zayron.simple.separator"
        runHook postInstall
      '';
    }
  ) { };

  pixel-cursors = inputs.pixel-cursors.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;
}
