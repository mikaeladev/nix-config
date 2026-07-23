{ inputs }:

final: _:

let
  pkgs = final;

  inherit (pkgs) callPackage;
  inherit (pkgs.stdenv.hostPlatform) system;
in

{
  apple-emoji = callPackage (
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

  apple-sf-pro = callPackage (
    {
      lib,
      stdenv,
      fetchurl,
      cpio,
      gzip,
      undmg,
      xar,
      ...
    }:

    stdenv.mkDerivation (finalAttrs: {
      pname = "apple-sf-pro";
      version = "8.0.1";

      src = fetchurl {
        name = "SF-Pro.dmg";
        url = "https://web.archive.org/web/20260723205749/https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
        hash = "sha256-YxGk8IQ6TS5hagsFx3US0x0uqVBFnPUmzbW5CZageU8=";
      };

      nativeBuildInputs = [
        cpio
        gzip
        undmg
        xar
      ];

      unpackPhase = ''
        runHook preUnpack

        undmg $src
        xar -xf 'SF Pro Fonts.pkg'
        gunzip -c 'SFProFonts.pkg/Payload' | cpio -i -vd

        runHook postUnpack
      '';

      installPhase = ''
        runHook preInstall

        install -Dm644 -t $out/share/fonts/truetype Library/Fonts/*.ttf
        install -Dm644 -t $out/share/fonts/opentype Library/Fonts/*.otf

        runHook postInstall
      '';

      meta = {
        description = "Apple's SF Pro typeface";
        homepage = "https://developer.apple.com/fonts/";
        maintainers = with lib.maintainers; [ mikaeladev ];
        license = lib.licenses.unfree;
        platforms = lib.platforms.linux;
      };
    })
  ) { };

  zayron-simple-separator = callPackage (
    { stdenv, fetchzip }:

    stdenv.mkDerivation {
      pname = "zayron-simple-separator";
      version = "1.4.7";

      src = fetchzip {
        # https://api.kde-look.org/ocs/v1/content/data/2137418
        name = "zayron.simple.separator.tar.xz";
        extension = "tar.xz";
        url = "https://web.archive.org/web/20260723211446/https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1710383493/zayron.simple.separator.tar.xz?response-content-disposition=attachment%3B%2520zayron.simple.separator.tar.xz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20260723%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260723T211446Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=ad733ba87174e540e97e31a4202875b33fc73d055e61de1e5a5a026df93a87e3";
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
