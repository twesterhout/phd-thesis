{
  description = "My PhD dissertation";

  nixConfig = {
    allowUnfree = true;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
  let
    lib = inputs.nixpkgs.lib;
    forEachSystem = f: lib.mapAttrs f inputs.nixpkgs.legacyPackages;

    pythonImports = ./imports.py;
    pythonPackages = python3: python3.withPackages (ps: with ps; [
      ipykernel jedi-language-server jupyter 
      h5py matplotlib numpy pandas scienceplots scipy
    ]);
    latexPackages = texlive: texlive.combine {
      inherit (texlive)
        scheme-small
	      adjustbox algorithm2e amsfonts amsmath babel bigfoot braket changes cfr-initials cm-super cprotect dvipng enumitem etoolbox
	      float fontspec framed gensymb graphics hycolor hyperref ifoddpage iftex import lettrine
	      ltxcmds mathspec memoir microtype minted natbib ninecolors notes2bib pgf pgfplots qrcode
	      relsize sfmath snapshot tabularray todonotes type1cm ulem url xcolor xpatch xstring sourceserifpro
        ;
    };

    overlay = final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          scienceplots = python-final.buildPythonPackage rec {
            pname = "scienceplots";
            version = "2.1.1";
            src = final.fetchPypi {
              inherit version;
              pname = "SciencePlots";
              hash = "sha256-2NGX40EPh+va0LnCZeqrWWCU+wgtlxI+g19rwygAq1Q=";
            };
            dependencies = with python-final; [ matplotlib ];
          };
        })
      ];

      fetchFromZenodo = { record, file, token, hash }: final.fetchzip {
        inherit hash;
        url = "https://zenodo.org/records/${record}/files/${file}?token=${token}&download=1&preview=1";
        extension = lib.last (lib.splitString "." file);
      };

      Introduction = final.callPackage ./chapters/Introduction { inherit pythonImports pythonPackages latexPackages; };
      PRB_97_20_205434_2018 = final.callPackage ./chapters/PRB_97_20_205434_2018 { inherit pythonImports pythonPackages latexPackages; };
      "2D_Materials_9_1_014004" = final.callPackage ./chapters/2D_Materials_9_1_014004 { inherit pythonImports pythonPackages latexPackages; };
      Proceedings_PAW_ATM_2023 = final.callPackage ./chapters/Proceedings_PAW_ATM_2023 { inherit pythonImports pythonPackages latexPackages; };
      PRB_106_L041104_2022 = final.callPackage ./chapters/PRB_106_L041104_2022 { inherit pythonImports pythonPackages latexPackages; };
      Nat_Commun_11_1593_2020 = final.callPackage ./chapters/Nat_Commun_11_1593_2020 { inherit pythonImports pythonPackages latexPackages; };
      Commun_Phys_6_275_2023 = final.callPackage ./chapters/Commun_Phys_6_275_2023 { inherit pythonImports pythonPackages latexPackages; };
    };
  in
  {
    packages = forEachSystem (system: pkgs': let pkgs = pkgs'.extend overlay; in {
      inherit (pkgs)
        Introduction
        PRB_97_20_205434_2018
        "2D_Materials_9_1_014004"
        Proceedings_PAW_ATM_2023
        PRB_106_L041104_2022
        Nat_Commun_11_1593_2020
        Commun_Phys_6_275_2023
      ;
    });
    devShells = forEachSystem (system: pkgs': let pkgs = pkgs'.extend overlay; in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ just source-serif (latexPackages pkgs.texlive) (pythonPackages pkgs.python3) ];
        shellHook = ''
          rm -f chapters/Introduction/assets && ln --symbolic ${pkgs.Introduction}/assets chapters/Introduction/assets
          rm -f chapters/PRB_97_20_205434_2018/assets && ln --symbolic ${pkgs.PRB_97_20_205434_2018}/assets chapters/PRB_97_20_205434_2018/assets
          rm -f chapters/2D_Materials_9_1_014004/assets && ln --symbolic ${pkgs."2D_Materials_9_1_014004"}/assets chapters/2D_Materials_9_1_014004/assets
          rm -f chapters/Proceedings_PAW_ATM_2023/assets && ln --symbolic ${pkgs.Proceedings_PAW_ATM_2023}/assets chapters/Proceedings_PAW_ATM_2023/assets
          rm -f chapters/PRB_106_L041104_2022/assets && ln --symbolic ${pkgs.PRB_106_L041104_2022}/assets chapters/PRB_106_L041104_2022/assets
          rm -f chapters/Nat_Commun_11_1593_2020/assets && ln --symbolic ${pkgs.Nat_Commun_11_1593_2020}/assets chapters/Nat_Commun_11_1593_2020/assets
          rm -f chapters/Commun_Phys_6_275_2023/assets && ln --symbolic ${pkgs.Commun_Phys_6_275_2023}/assets chapters/Commun_Phys_6_275_2023/assets
        '';
      };

      julia = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          (julia-bin.withPackages [ "LinearAlgebra" "FFTW" "HDF5" "LsqFit" ])
        ];
      };
    });
  }
  // forEachSystem (system: pkgs: { formatter = pkgs.nixpkgs-fmt; });
}
