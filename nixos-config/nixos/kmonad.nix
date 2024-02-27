{ pkgs, config, lib, ... }:

let
  cfg = config.services.kmonad;

  binary = pkgs.fetchurl {
    url = "https://github.com/kmonad/kmonad/releases/download/0.4.2/kmonad";
    sha256 = "0j73dzsfnsa7s96gnxhy9v2wz4l8pln0safdlbkz5j4gdasz3lsl";
  };

  kmonad = pkgs.runCommand "kmonad" { } ''
    #!${pkgs.stdenv.shell}
    mkdir -p $out/bin
    cp ${binary} $out/bin/kmonad
    chmod +x $out/bin/*
  '';

in

with lib;
{
  options.services.kmonad = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, run kmonad after boot.
      '';
    };

    configfile = mkOption {
      type = types.path;
      default = "";
      example = "my-config.kbd";
      description = ''
        The config file for kmonad.
      '';
    };

    package = mkOption {
      type = types.package;
      default = kmonad;
      example = "import ./default.nix";
      description = ''
        The kmonad package.
      '';
    };
  };

  config = {
    environment.systemPackages = [ cfg.package ];

    users.groups.uinput = { };

    services.udev.extraRules = mkIf cfg.enable
      ''
        # KMonad user access to /dev/uinput
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';

    systemd.services.kmonad = mkIf cfg.enable {
      enable = true;
      description = "KMonad";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/kmonad " + cfg.configfile;
      };
      wantedBy = [ "graphical.target" ];
    };
  };
}

