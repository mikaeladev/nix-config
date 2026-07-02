{
  programs.nixvim.opts = {
    # appearance
    number = true;
    cursorline = true;
    winborder = "rounded";

    # formatting
    shiftwidth = 2;
    autoindent = true;
    breakindent = true;
    copyindent = true;
    preserveindent = true;

    # files
    swapfile = false;
    undofile = true;
    autoread = true;
    writebackup = false;
    fileencoding = "utf-8";

    # mouse
    mouse = "a";

    # misc
    confirm = true;
  };
}
