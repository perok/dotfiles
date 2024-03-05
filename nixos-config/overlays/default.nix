# This file defines overlays
{ inputs, ... }:
let
  modificationsStableUnstable = final: prev: {
    sbt = prev.sbt.override {
      jre = prev.jdk17;
    };
    jre = prev.jdk17;
    jdk = prev.jdk17;
  };
in
{
  # -Overlays is an list, the order matters. Overlays are basically applied one after the other.
  # -First argument (final) is pkgs after that overlay is applied, and the second one (prev) is pkgs before the overlay is applied.
  # - Usually always use final, unless you're accessing something that overlay modified (for example, nginxStable).

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    #sbt = prev.sbt.override {
    #  jre = prev.jdk17;
    #};
    #jre = prev.jdk17;
    #jdk = prev.jdk17;
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    #  });
  };
  modificationsStableUnstable = modificationsStableUnstable;

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      overlays = [ modificationsStableUnstable ];
    };
  };
}
