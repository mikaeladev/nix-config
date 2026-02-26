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
    install -Dm644 -t $out/share/fonts/truetype *.ttf
    install -Dm644 -t $out/share/fonts/opentype *.otf
    runHook postInstall
  '';
}
