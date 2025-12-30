{ config, lib, ... }:

let
  inherit (lib.custom.networking)
    mkEthernetConfig
    mkWifiConfig
    mkSurfsharkConfig
    mkNameserverConfig
  ;
in

{
  networking = {
    hostName = "nixos-desktop";

    networkmanager = {
      enable = true;
      dns = "none";

      ensureProfiles = {
        environmentFiles = [ config.age.secrets.networks.path ];

        profiles = {
          ethernet = mkEthernetConfig {
            name = "Ethernet";
            uuid = "288caf42-84eb-4965-ae3a-7836e49e693c";
          };

          home-wifi = mkWifiConfig {
            name = "Home WiFi";
            uuid = "3037a926-f08d-4ebd-a2ea-83bfd80e1a79";
            ssid = "$HOME_WIFI_SSID";
            pass = "$HOME_WIFI_PASS";
          };

          surfshark-brussels = mkSurfsharkConfig {
            name = "Surfshark :: Brussels, Belgium";
            uuid = "87823505-5ab1-43f5-87eb-a46c69ff2c04";
            endpoint = "be-bru.prod.surfshark.com:51820";
            publicKey = "9wZOjtwuKEc0GBcvc3xJQ4Kjo8G3EMXu6zJRzbanOjc=";
            privateKey = "$SURFSHARK_PRIVATE_KEY";
          };

          surfshark-dublin = mkSurfsharkConfig {
            name = "Surfshark :: Dublin, Ireland";
            uuid = "9c587461-facb-42ec-8fee-d7f618d2b920";
            endpoint = "ie-dub.prod.surfshark.com:51820";
            publicKey = "TjYxodFNdGlefxnWqe9vWWJHnz3meYWWhiIJyU8rgg8=";
            privateKey = "$SURFSHARK_PRIVATE_KEY";
            autoconnect = true;
          };

          surfshark-london = mkSurfsharkConfig {
            name = "Surfshark :: London, UK";
            uuid = "d884b8ea-a779-42ab-add0-2f73c211ff8c";
            endpoint = "uk-lon.prod.surfshark.com:51820";
            publicKey = "iBJRXLZwXuWWrOZE1ZrAXEKMgV/z0WjG0Tks5rnWLBI=";
            privateKey = "$SURFSHARK_PRIVATE_KEY";
          };

          surfshark-paris = mkSurfsharkConfig {
            name = "Surfshark :: Paris, France";
            uuid = "455e3c08-1e6f-4a5f-ac5d-8dfcd25e2f8d";
            endpoint = "fr-par.prod.surfshark.com:51820";
            publicKey = "AsvLuvKKADdc67aA/vHA3vb61S6YnGGx2Pd4aP4wal8=";
            privateKey = "$SURFSHARK_PRIVATE_KEY";
          };
        };
      };
    };

    # unnecessary with manual dns
    useDHCP = false;
    dhcpcd.enable = false;

    # use cloudflare and google dns
    nameservers = mkNameserverConfig "ipv4";
  };
}
