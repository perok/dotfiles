{ pkgs, config, lib, username, ... }:
{
  programs.hyprland.enable = true;

  # TODO already a part of plasma6 = true

  # Enable helpful DBus services.
  services.accounts-daemon.enable = true;
  services.dbus.packages = [
    pkgs.gcr # To make pkgs.pinentry-gnome3 work
  ];

  programs.dconf.enable = true;
  services.udisks2.enable = true;

  services.upower.enable = config.powerManagement.enable;

  services.gnome = { gnome-keyring.enable = true; };

  security.pam.services.login.enableGnomeKeyring = true;

  environment = {
    #sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    #sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      kdePackages.polkit-kde-agent-1

      # For qt6 wayland support. Needed?
      kdePackages.qtwayland

      # Expected by apps like firefox
      gnome.adwaita-icon-theme
    ];
  };

  services.xserver.displayManager.sddm = {
    package = pkgs.kdePackages.sddm;
    # TODO not working??
    #theme = lib.mkDefault "breeze";
    #extraPackages = with pkgs.kdePackages; [
    #  breeze-icons
    #  kirigami
    #  qtsvg
    #];
  };

  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "xdph" "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
      };
    };
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  # For thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  #programs.ssh.askPassword = mkDefault "${kdePackages.ksshaskpass.out}/bin/ksshaskpass";

}
