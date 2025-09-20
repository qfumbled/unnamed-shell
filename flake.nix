{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    astal.url = "github:brainlessbitch/astal/feat/brightness";
  };

  outputs =
    {
      self,
      nixpkgs,
      astal,
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      astal-pkgs = astal.packages.x86_64-linux;
    in
    with pkgs;
    {
      packages.x86_64-linux.default = stdenv.mkDerivation {
        name = "shell";

        src = ./.;

        nativeBuildInputs = [
          meson
          ninja
          pkg-config
          vala
          gcc
          dart-sass
          gobject-introspection
          wrapGAppsHook4
        ];
        buildInputs = with astal-pkgs; [
          pkgs.gtk4
          pkgs.gtk4-layer-shell
          pkgs.libadwaita
          io
          astal4
          apps
          battery
          bluetooth
          brightness
          (mpris.overrideAttrs { patches = [ ./astal-mpris.patch ]; })
          network
          notifd
          wireplumber
        ];
      };
    };
}
