{ pkgs ? import <nixpkgs> { } }:
let
  #pyln-client = pkgs.callPackage ./pyln-client.nix { inherit pkgs; };
in
pkgs.mkShell rec {
  packages = [
   # pyln-client
    pkgs.magic-wormhole
    pkgs.python38Packages.pip
    pkgs.bc
    pkgs.htop
    pkgs.less
    pkgs.python38Full
    pkgs.bitcoind
    pkgs.clightning
    pkgs.pstree

    ## Uncomment the following if you want to hack on Rust and Go CLN plugins
    #pkgs.rustc
	#pkgs.rustfmt
	#pkgs.cargo
	#pkgs.cargo-edit
    #pkgs.rust-analyzer
    #pkgs.go
    #pkgs.gopls
  ];

    currentDir = builtins.getEnv "PWD";
    PYTHON_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [];
    PYTHONBIN = "${pkgs.python38Full}/bin/python3.8";
    LANG = "en_US.UTF-8";
    PIP_PREFIX="${currentDir}/_build/pip_packages";
    PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH";
    PATH="$PIP_PREFIX/bin:$PATH";

    shellHook = "
        unset SOURCE_DATE_EPOCH
        wget https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/startup_regtest.sh
        source startup_regtest.sh
    ";
}
