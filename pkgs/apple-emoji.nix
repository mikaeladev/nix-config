{ stdenv, fetchurl, ... }:

let
  release = "18.4";
  filename = "AppleColorEmoji.ttf";
in

stdenv.mkDerivation {
  pname = "apple-emoji";
  version = "${release}.0";

  src = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v${release}/${filename}";
    sha256 = "1ggahpw54rjpxirjbyarwd5gvvg1hi08zw4c1nab8dqls5xhgzd4";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/${filename}
    runHook postInstall
  '';
}
