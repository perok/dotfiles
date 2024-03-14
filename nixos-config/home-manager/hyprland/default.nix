{ config, pkgs, outputs, ... }:
let
  hyprlandRotateLayout = pkgs.writeShellScriptBin "hyprland-rotate-layout" ''
    current_layout=$(hyprctl getoption general:layout | grep -oP 'str: \K\w+')
    if [ "$current_layout" == "dwindle" ]; then
      hyprctl keyword general:layout master
      echo "Switched layout to master."
    else
      hyprctl keyword general:layout dwindle
      echo "Switched layout to dwindle."
    fi
  '';
in
{

  home.packages = with pkgs;
    [
      hyprlandRotateLayout

      waybar # the status bar
      brightnessctl
      # TODO logout, hypridle, hyprlock, etc
      #swaybg # the wallpaper
      hypridle # the idle timeout
      hyprlock # locking the screen
      wlogout # logout menu TODO add to meny
      wl-clipboard # copying and pasting
      #hyprpicker # color picker
      wdisplays # monitor management

      #pkgs-unstable.hyprshot # screen shot
      grim # taking screenshots
      slurp # selecting a region to screenshot
      #wf-recorder # creen recording

      xfce.thunar

      #yad # a fork of zenity, for creating dialogs

      # audio
      networkmanagerapplet # provide GUI app: nm-connection-editor
      playerctl # MPRIS media control
    ];

  programs.rofi = {
    enable = true;
    package = pkgs.unstable.rofi-wayland;
  };

  services.mako = {
    enable = true;
    font = "Souce Code Pro 10";
    defaultTimeout = 5000;
    extraConfig = builtins.readFile ./mako-config-dark;
  };
  # TODO https://github.com/NixOS/nixpkgs/issues/280041#issuecomment-1951437276
  # services.swayosd.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # TODO change font to nerd font supported
    #${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}

    style = ./waybar.css;
    settings = [{
      height = 30;
      layer = "top";
      position = "top";
      #spacing = 4;
      modules-left = [
        "custom/exit"
        "hyprland/workspaces"
        #"hyprland/submap"
        #"idle_inhibitor"
        "backlight"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
        "wireplumber"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "hyprland/language"
        # TODO tray not working
        "tray"
        "clock"
      ];

      battery = {
        format = "{capacity}% {icon} ";
        format-alt = "{time} {icon}";
        format-charging = "{capacity}% 🗲";
        format-icons = [ "" "" "" "" "" ];
        format-plugged = "{capacity}% ";
        states = {
          critical = 15;
          warning = 30;
        };
      };

      tray = {
        spacing = 10;
      };

      clock = {
        format-alt = "{:%Y-%m-%d}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };

      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };

      memory = { format = "{}% "; };

      "custom/exit" = {
        format = "Exit";
        # TODO not working
        on-click = "${pkgs.wlogout}/bin/wlogout";
      };

      "hyprland/language" = {
        format-en = "EN";
        format-no = "NO";
        separate-outputs = true;
        # TODO https://github.com/Alexays/Waybar/issues/2425
        on-click = "${pkgs.hyprland}/bin/hyprctl switchxkblayout my-kmonad-output next";
        # hyperctl devices
        keyboard-name = "my-kmonad-output";
      };

      network = {
        interval = 1;
        format-wifi = "{essid} ({signalStrength}%)  ";
        format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        # TODO not working
        # on-click = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      };

      wireplumber = {
        format = "{volume}% {icon}";
        format-muted = "";

        format-icons = [ "" "" "" ];
        #  on-click = "helvum";
      };

      backlight = {
        format = "{percent}% {icon}";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
      };

      temperature = {
        critical-threshold = 80;
        format = "{temperatureC}°C {icon}";
        format-icons = [ "" "" "" ];
      };
    }];
  };

  # TODO pkgs referenes?
  home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;

  wayland.windowManager.hyprland = {
    enable = true;
    #extraConfig = builtins.readFile ./hypr.conf;
    extraConfig = ''
      # Two finger right click
      input {
        # localectl list-x11-keymap-layouts
        kb_layout = us(altgr-intl),no
        touchpad {
          clickfinger_behavior = 1
        }
      }
      master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true
      }

      animations {
        #enabled = no
      }

      misc {
        # disable_hyprland_logo = true
        # disable_splash_rendering = true
        disable_autoreload = true
      }

      # Wayland fix vscode
      # TODO https://forums.developer.nvidia.com/t/550-54-14-cannot-create-sg-table-for-nvkmskapimemory-spammed-when-launching-chrome-on-wayland/284775
      # env = NIXOS_OZONE_WL,1
      # unscale XWayland
      xwayland {
        force_zero_scaling = true
      }
      #env = XCURSOR_SIZE,32
      # nvidia multi monitor
      env = WLR_NO_HARDWARE_CURSORS,1

      exec-once=${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &
      exec-once=hypridle
      # Notificatio engine
      exec-once=mako &
      exec-once=blueman-applet
      exec-once=nm-applet --indicator &
    '';
    # Inspiration https://github.com/ryan4yin/nix-config/blob/main/home/linux/desktop/hyprland/conf/hyprland.conf
    # https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.conf
    settings = {
      "$mod" = "SUPER";
      "$term" = "alacritty";
      "$files" = "thunar";
      "$browser" = "firefox";

      binde = [
        # fn buttons
        ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind =
        [
          "ALT,SPACE,exec, rofi -show combi"
          "CTRLALT,T,exec,$term"
          "$mod, F, exec, firefox,"
          ", Print, exec, grim -g \"$(slurp -d)\" - | wl-copy"

          # fn
          ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86AudioPause,        exec, playerctl play-pause"
          ",XF86AudioPlay,         exec, playerctl play-pause"
          ",XF86AudioPrev,         exec, playerctl previous"
          ",XF86AudioNext,         exec, playerctl next"

          # https://www.reddit.com/r/hyprland/comments/15svfuz/comment/jwgi6xt/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
          "$mod, F, fullscreen"

          # Workspace
          "$mod CTRL,j,workspace,+1"
          "$mod CTRL,k,workspace,-1"

          # Focus
          "$mod,h,movefocus,l"
          "$mod,l,movefocus,r"
          "$mod,k,movefocus,u"
          "$mod,j,movefocus,d"

          # Move
          "$mod SHIFT,h,movewindow,l"
          "$mod SHIFT,l,movewindow,r"
          "$mod SHIFT,k,movewindow,u"
          "$mod SHIFT,j,movewindow,d"

          "$mod, Return, layoutmsg, swapwithmaster master"
          "$mod, C, killactive,"
          "$mod, backslash, exec,hyprland-rotate-layout"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList
            (
              x:
              let
                n = toString (x + 1);
              in
              [
                "$mod, ${n}, workspace, ${n}"
                "$mod SHIFT, ${n}, movetoworkspace, ${n}"
              ]
            )
            9)
        );
    };
  };


}

