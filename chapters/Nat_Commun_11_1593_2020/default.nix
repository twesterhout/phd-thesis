{ stdenv
, fetchzip
, python3
, pythonImports
, pythonPackages
, texlive
, latexPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Nat_Commun_11_1593_2020";
  version = "1.0";
  src = ./.;
  data = fetchzip {
    url = "https://zenodo.org/records/14931097/files/Nat_Commun_11_1593_2020.zip?token=eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImFjYjViYWY2LWM1YzAtNDRiOS1hMDhkLTVlYTVjZGVjNTc1NiIsImRhdGEiOnt9LCJyYW5kb20iOiI3NmFiZTdmYjdkOTc2NTIyMWE3NzQ4Mjc0OTQyNTYyZiJ9.bhFFVL-QvsVctBsvvUl2yRnKolodaGSbtfv7dOXGJrywv0Kb1n4ryHiiP4HV-4EbX-27HjHXIKPk6UbEkes7dg&download=1&preview=1";
    hash = "sha256-gHoxRPjjXRA7whMLWaY3ojrjRLL9bedlCvM8c7f962w=";
    extension = "zip";
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
