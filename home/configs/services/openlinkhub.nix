{
  services.openlinkhub = {
    enable = true;

    settings = {
      ramTempViaHwmon = true;
    };

    dashboard = {
      enable = true;
      settings = {
        celsius = true;
        languageCode = "en_US";
        pageTitle = "OpenLinkHub WebUI";
      };
    };

    memory = {
      enable = true;
      sku = "CMW16GX4M2D3600C18";
      smb = "i2c-0";
      type = 4;
    };
  };
}
