{ pkgs, ... }:

{
  lib.custom = {
    mkThunderbirdAddon =
      {
        name,
        version,
        addonId,
        url ? "",
        urls ? [ ],
        sha256,
        meta,
      }:
      pkgs.stdenv.mkDerivation {
        inherit version meta;

        pname = "thunderbird-addons-${name}";

        src = pkgs.fetchurl { inherit url urls sha256; };

        buildCommand = ''
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -Dm644 "$src" "$dst/${addonId}.xpi"
        '';
      };
  };
}
