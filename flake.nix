{
  description = "EclipseCON 2022 keyboard talk slides";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      devshell,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlays.default ];
          };
        in
        {
          default = pkgs.devshell.mkShell {
            name = "eclipsecon-keyboard-talk";

            packages = [ pkgs.marp-cli ];

            commands = [
              {
                name = "slides-build";
                help = "Convert slides.md to HTML";
                command = "marp --bespoke.progress slides.md";
              }
              {
                name = "slides-serve";
                help = "Serve the presentation in watch mode on http://localhost:8081/";
                command = "PORT=8081 marp --bespoke.progress -s .";
              }
            ];
          };
        }
      );
    };
}

