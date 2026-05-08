{
  description = "Nix packaging workspace for ISC Stork";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        iscStork = pkgs.callPackage ./pkgs/isc-stork { };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        packages = {
          inherit (iscStork)
            isc-stork-source-layout
            isc-stork-server-src
            isc-stork-agent-src
            isc-stork-ui-src
            ;

          default = iscStork.isc-stork-source-layout;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bundler
            curl
            git
            gh
            go
            jq
            nodejs_22
            nodePackages.npm
            pkg-config
            postgresql
            protobuf
            ruby
          ];

          shellHook = ''
            echo "nix-isc-stork dev shell"
            echo "Upstream: https://github.com/isc-projects/stork"
            echo "Use explicit package names like isc-stork-server; nixpkgs already has an unrelated stork package."
          '';
        };
      }
    );
}
