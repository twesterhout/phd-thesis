{ stdenv
, fetchzip
, python3
, pythonImports
, pythonPackages
, texlive
, latexPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "PRB_106_L041104_2022";
  version = "1.0";
  src = ./.;
  data = fetchzip {
    url = "https://zenodo.org/records/14924491/files/twesterhout/correlated-hoppings-v${finalAttrs.version}.zip";
    hash = "sha256-gryvtar0VU4xBoFEuN1XLzt5Sp8hhblr5pKBlrSyIC8=";
  };
  nativeBuildInputs = [ (latexPackages texlive) (pythonPackages python3) ];
  configurePhase = ''
    ln --symbolic -v ${pythonImports} imports.py
    ln --symbolic -v ${finalAttrs.data} data
    export MPLCONFIGDIR=$(mktemp -d)
  '';
  buildPhase = "jupyter nbconvert --to script Figures.ipynb && python3 Figures.py";
  installPhase = "install -d $out/assets && install -D assets/*.pgf assets/*.png  $out/assets";
})
