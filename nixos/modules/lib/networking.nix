{ globals, ... }:

let
  inherit (builtins) concatStringsSep;

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
    dns = (concatStringsSep ";" ipv4Nameservers) + ";";
    ignore-auto-dns = true;
    method = "auto";
  };

  ipv6 = {
    dns = (concatStringsSep ";" ipv6Nameservers) + ";";
    ignore-auto-dns = true;
    addr-gen-mode = "stable-privacy";
    method = "auto";
  };
in

{
  mkEthernetConfig =
    { name, uuid }:
    {
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

  mkNameserverConfig =
    type:
    (
      if type == "ipv4" then
        ipv4Nameservers
      else if type == "ipv6" then
        ipv6Nameservers
      else
        throw "Invalid nameserver type"
    );
}
