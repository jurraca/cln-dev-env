

{ pkgs ? import <nixpkgs> { } }:
#let
#    startup_regtest = pkgs.fetchgit {
#        url = "https://github.com/ElementsProject/lightning/";
#        sparseCheckout = [''
#          contrib/startup_regtest.sh
#        ''];
#        sha256 = "0000000000000000000000000000000000000000000000000000";
#    };
#in

#let
#    pyln-client = buildPythonPackage rec {
#      pname = "pyln-client";
#      version = "23.2";
#      src = pkgs.fetchPypi {
#        inherit pname version;
#        sha256 = pkgs.lib.fakeSha256;
#      };
#      doCheck = false;
#      propagatedBuildInputs = [
#        # Specify dependencies
#      ];
#    };
#    pythonEnv = pkgs.python38.withPackages(ps: with ps; [ pyln-client ] );
#in
pkgs.mkShell rec {
  packages = [
    pkgs.magic-wormhole
    pkgs.python38Packages.pip
    pkgs.busybox
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
