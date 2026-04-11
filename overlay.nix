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
      dontBuild = true;

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

      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm644 -t "$out/share/fonts/truetype" *.ttf
        install -Dm644 -t "$out/share/fonts/opentype" *.otf
        runHook postInstall
      '';
    }
  ) { };

  pixel-cursors = inputs.pixel-cursors.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;
}
