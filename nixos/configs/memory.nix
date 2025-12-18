{ ... }:

{
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 25; # 8G
    algorithm = "zstd";
  };
}
