{ config, globals, ... }:

let
  ipv4Nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  ipv6Nameservers = [
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
  ];

  ipv4 = {
    dns = (builtins.concatStringsSep ";" ipv4Nameservers) + ";";
    ignore-auto-dns = true;
    method = "auto";
  };

  ipv6 = {
    dns = (builtins.concatStringsSep ";" ipv6Nameservers) + ";";
    ignore-auto-dns = true;
    addr-gen-mode = "stable-privacy";
    method = "auto";
  };

  mkEthernetConfig = { name, uuid }: {
    inherit ipv4 ipv6;

    connection = {
      inherit uuid;
      id = name;
      type = "ethernet";
    };

    ethernet = {
      auto-negotiate = true;
    };
  };

  mkWifiConfig =
    {
      name,
      uuid,
      ssid,
      pass,
    }:
    {
      inherit ipv4 ipv6;

      connection = {
        inherit uuid;
        id = name;
        type = "wifi";
        permissions = "";
      };

      wifi = {
        inherit ssid;
        mode = "infrastructure";
      };

      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = pass;
      };
    };

  mkSurfsharkConfig =
    {
      name,
      uuid,
      endpoint,
      publicKey,
      privateKey,
      autoconnect ? false,
    }:
    {
      connection = {
        inherit uuid autoconnect;
        id = name;
        type = "wireguard";
        permissions = "user:${globals.mainuser.username}:;";
      };

      ipv4 = {
        address1 = "10.14.0.2/16";
        dns = "162.252.172.57;149.154.159.92;";
        dns-search = "~.;";
        method = "manual";
      };

      ipv6 = {
        addr-gen-mode = "stable-privacy";
        method = "ignore";
      };

      wireguard = {
        private-key = privateKey;
        fwmark = 51820;
        listen-port = 32;
        mtu = 1280;
      };

      "wireguard-peer.${publicKey}" = {
        inherit endpoint;
        persistent-keepalive = 30;
        allowed-ips = "0.0.0.0/0;";
      };
    };
in

{
  networking = {
    hostName = "nixos";

    # unnecessary for manual dns
    useDHCP = false;
    dhcpcd.enable = false;

    # use cloudflare and google dns
    nameservers = ipv4Nameservers;

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
  };
}
