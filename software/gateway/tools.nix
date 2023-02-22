{
  pkgs,
  lib,
  ...
}: {
  programs.neovim.enable = lib.mkDefault true;
  programs.neovim.viAlias = lib.mkDefault true;
  programs.neovim.vimAlias = lib.mkDefault true;
  programs.neovim.defaultEditor = lib.mkDefault true;

  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.ohMyZsh.enable = lib.mkDefault true;
  programs.zsh.enableCompletion = lib.mkDefault true;
  programs.zsh.enableBashCompletion = lib.mkDefault true;
  programs.zsh.enableGlobalCompInit = lib.mkDefault false;
  programs.zsh.autosuggestions.enable = lib.mkDefault true;
  programs.zsh.interactiveShellInit = lib.mkDefault "source '${pkgs.grml-zsh-config}/etc/zsh/zshrc'";

  programs.mtr.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    exfat
    sshfs
    strace
    tmux
    curl
    httpie
    gotop
    htop
    mc
    git
    neofetch
    pstree
    ranger
    screen
    tree
    whois
  ];
}
