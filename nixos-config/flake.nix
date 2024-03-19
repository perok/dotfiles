{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable/c75037bbf9093a2acb617804ee46320d6d1fea5a";
    nixpkgs.url = "github:NixOS/nixpkgs/c75037bbf9093a2acb617804ee46320d6d1fea5a";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable/c75037bbf9093a2acb617804ee46320d6d1fea5a";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/c75037bbf9093a2acb617804ee46320d6d1fea5a";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/7b3fca5adcf6c709874a8f2e0c364fe9c58db989";
      #url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq/971f40f0ca2dad2ab79aeb5ddf1beb818bb68bed";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, auto-cpufreq, ... }@inputs:
    let
      inherit (self) outputs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Please replace my-nixos with your hostname
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            username = "perok";
            hostname = "nixos";
            inherit inputs outputs;
          };
          modules = [
            ./hosts/nixos

            auto-cpufreq.nixosModules.default

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              #home-manager.pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.perok = import ./home;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
            }
          ];
        };
      };
    };
}
