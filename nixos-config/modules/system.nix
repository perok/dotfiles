{ pkgs, config, lib, ... }:
{

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.perok = {
    isNormalUser = true;
    description = "Peri";
    extraGroups = [ "networkmanager" "docker" "wheel" "input" "uinput" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      # TODO move to home
      firefox
      kate
      #  thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    gnumake # nvim something
    wget
    curl
    ranger
    stow
    just
    lshw
    killall

    git

    # TODO move to home
    #pkgs.jetbrains-toolbox https://github.com/NixOS/nixpkgs/issues/240444
    vscode # vscode-fhs?
    spotify
    #libsForQt5.bismuth
    slack
  ];

  programs.zsh = {
    enable = true;
    #completionInit = "";
    enableGlobalCompInit = false;
    #promptInit = "";
  };

  # TODO move to home-manaager when it controls zsh
  programs.direnv.enable = true;

  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true;
  };


}
