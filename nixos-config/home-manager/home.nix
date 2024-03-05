{ config, pkgs, outputs, ... }:
{
  home.username = "perok";
  home.homeDirectory = "/home/perok";
  home = {
    keyboard = {
      #layout = "de";
      # https://github.com/nix-community/home-manager/issues/4841
      # options = [ "caps:escape" ];
    };
  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};


  # TODO how to make this unnecessary? share between nixos and home
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.modificationsStableUnstable
      outputs.overlays.unstable-packages
    ];
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
      # libsForQt5.applet-window-buttons https://github.com/psifidotos/applet-window-buttons/issues/193
      filelight

      unstable.neovide
      sublime-merge

      # nil # nix ls. Currently installed with nix profile

      xclip # vim clipboard integration

      nodejs_21
      volta
      pipx
      gcc9
      cargo

      chromium
      remmina

      steam
      mpv

      #coursier
      unstable.metals
      unstable.bloop
      unstable.scala-cli
      #(unstable.sbt.override { jre = my-jdk; })
      unstable.sbt
      unstable.scalafmt
      unstable.scalafix

      neofetch
      nnn # terminal file manager

      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processer https://github.com/mikefarah/yq
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      bfs #fd # fast find
      difftastic
      htop

      # networking tools
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      discord

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      gnupg

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      glow # markdown previewer in terminal

      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ];

  # https://github.com/nix-community/home-manager/tree/master/modules/programs

  programs.java = {
    enable = true;
  };

  #programs.zsh = {
  #};
  #programs.fzf = {
  #  enable = true;
  #};
  programs.gh = {
    enable = true;
    package = pkgs.unstable.gh;
    extensions = with pkgs; [
      unstable.gh-actions-cache
      unstable.gh-dash
    ];
    settings = {
      # Workaround for https://github.com/nix-community/home-manager/issues/4744
      version = 1;
      editor = "nvim";
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    # Needed to configure this. Why was this override needed?
    # Error was: gpg: signing failed: No pinentry
    pinentryFlavor = "qt";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  #programs.git = {
  #  enable = true;
  #  userName = "Per Oyvind Kanestrom";
  #  userEmail = "per.kanestrom@bekk.no";
  #};

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

