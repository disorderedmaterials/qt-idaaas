{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };
  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      q = import ./nix/qt {
        inherit (pkgs)
          newScope lib stdenv fetchurl fetchgit fetchpatch fetchFromGitHub
          makeSetupHook makeWrapper bison cups harfbuzz libGL perl ninja
          VideoToolbox writeText gtk3 dconf libglvnd darwin buildPackages;
        inherit (pkgs.gst_all_1)
          gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi;

        cmake = pkgs.cmake.overrideAttrs (attrs: {
          patches = attrs.patches ++ [ ./nix/qt/patches/cmake.patch ];
        });
      };

    in
    { packages.x86_64-linux = q; };
}
