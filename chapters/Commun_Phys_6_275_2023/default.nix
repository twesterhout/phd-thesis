{ stdenv
, fetchFromZenodo
, python3
, pythonImports
, pythonPackages
, texlive
, latexPackages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Commun_Phys_6_275_2023";
  version = "1.1";
  src = ./.;
  data = fetchFromZenodo {
    record = "14973515";
    file = "experiments.zip";
    token = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjEzZjE2MmI5LWY3ODctNGE0Ni1hYTdjLWUxYzI3NDlmNzM4ZCIsImRhdGEiOnt9LCJyYW5kb20iOiI1NmYxM2QxNmMzY2VhYjljOGFiOWJkMjc2MDkxNmQ5YiJ9.wMAVaPZs5U0i2_EITByGsmiTnU2ymZFwYrDK7WLBHpc5xLYqEkb0mHHFv9yqJURH-tVe7xzIJ_t082xbrpDj4g";
    hash = "sha256-ql5ItRTLE0H+dvBvmKvDhpoHWNF/PKhX0Lcq/9rKV+c=";
  };
  nativeBuildInputs = [ (latexPackages texlive) (pythonPackages python3) ];
  configurePhase = ''
    ln --symbolic -v ${pythonImports} imports.py
    mkdir -p data && ln --symbolic -v ${finalAttrs.data} data/experiments
    export MPLCONFIGDIR=$(mktemp -d)
  '';
  buildPhase = "jupyter nbconvert --to script Figures.ipynb && python3 Figures.py";
  installPhase = "install -d $out/assets && install -D assets/*.pgf assets/*.png  $out/assets";
})
