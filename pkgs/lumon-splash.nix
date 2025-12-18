{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  pname = "lumon-splash";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nobreDaniel";
    repo = "lumonSplash";
    rev = "4cd386b1e70ae971963942cf1914575bf5452d14";
    hash = "sha256-e5btsrhkdynseGmZM0n2kr0egDas8/glnG5m8zvNVLw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/plasma/look-and-feel *
    runHook postInstall
  '';
}
