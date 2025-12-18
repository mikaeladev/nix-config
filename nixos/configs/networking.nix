{ ... }:

{
  networking = {
    hostName = "nixos-desktop";

    networkmanager = {
      enable = true;
      dns = "none";
    };
    
    # unnecessary with manual dns
    useDHCP = false;
    dhcpcd.enable = false;
    
    # use cloudflare and google dns
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
