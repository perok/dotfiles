{ pkgs, config, lib, username, ... }:
{

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set the default editor to vim
  environment.variables.EDITOR = "vim";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
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

  # Location for things like gammestep (redshift)
  services.geoclue2.enable = true;

  # fc-list
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      ubuntu_font_family
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-color-emoji
      (nerdfonts.override { fonts = [ "Hasklig" "DroidSansMono" "SourceCodePro" ]; })
    ];
    # TODO useful?
    # Where are the emojis? ☘️
    # This? https://github.com/ryan4yin/nix-config/blob/82b65f775369818a9586a44b172833b51e9e47f0/modules/system.nix#L96
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "Souce Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];

        # TODO JoyPixels
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };



}
