# nix version of cabal-ghc901.project
{ pkgs, hackage }:

let
  disabledPlugins = [
    "hls-brittany-plugin"
    "hls-stylish-haskell-plugin"
  ];

  hpkgsOverride = hself: hsuper:
    with pkgs.haskell.lib;
    {
      fourmolu = hself.callCabal2nix "fourmolu" hackage.fourmolu {};
      primitive-extras = hself.primitive-extras_0_10_1_2;
      ghc-exactprint = hself.callCabal2nix "ghc-exactprint" hackage.ghc-exactprint {};
      constraints-extras = hself.callCabal2nix "constraints-extras" hackage.constraints-extras {};
      retrie = hself.callCabal2nix "retrie" hackage.retrie {};
      hlint = doJailbreak (hself.callCabal2nix "hlint" hackage.hlint {});

      # Re-generate HLS drv excluding some plugins
      haskell-language-server =
        hself.callCabal2nixWithOptions "haskell-language-server" ./.
        (pkgs.lib.concatStringsSep " " [
          "-f-brittany"
          "-f-stylishhaskell"
          "-f-hlint"
          "-f-haddockComments"
          "-f-alternateNumberFormat"
          "-f-eval"
        ]) { };

      # YOLO
      mkDerivation = args:
        hsuper.mkDerivation (args // {
          jailbreak = true;
          doCheck = false;
        });
    };
in {
  inherit disabledPlugins;
  tweakHpkgs = hpkgs: hpkgs.extend hpkgsOverride;
}