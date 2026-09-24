# The browser version, built with GHCJS from the package set miso 1.8 pins.
# nix-build leaves the page in result/bin/stql-web.jsexe.
with (import (builtins.fetchGit {
  url = "https://github.com/dmjio/miso";
  ref = "refs/tags/1.8";
}) {});
let
  # the sources, without git history or the products of earlier builds
  src = pkgs.lib.cleanSourceWith {
    src = pkgs.lib.cleanSource ./.;
    filter = path: type:
      !(builtins.elem (baseNameOf path) [ "site" "stql" ".testrun" ]);
  };
in
pkgs.haskell.packages.ghcjs.callCabal2nix "stql-web" src {}
