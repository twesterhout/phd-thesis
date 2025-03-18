{ lib
, stdenv
, texlive
, latexPackages
, just
, Introduction
, PRB_97_20_205434_2018
, Materials_9_1_014004
, Proceedings_PAW_ATM_2023
, PRB_106_L041104_2022
, Nat_Commun_11_1593_2020
, Commun_Phys_6_275_2023
}:

stdenv.mkDerivation {
  pname = "thesis";
  version = "1.0";
  src = ./.;
  configurePhase = ''
     ln --symbolic ${Introduction}/assets chapters/Introduction/assets
     ln --symbolic ${PRB_97_20_205434_2018}/assets chapters/PRB_97_20_205434_2018/assets
     ln --symbolic ${Materials_9_1_014004}/assets chapters/2D_Materials_9_1_014004/assets
     ln --symbolic ${Proceedings_PAW_ATM_2023}/assets chapters/Proceedings_PAW_ATM_2023/assets
     ln --symbolic ${PRB_106_L041104_2022}/assets chapters/PRB_106_L041104_2022/assets
     ln --symbolic ${Nat_Commun_11_1593_2020}/assets chapters/Nat_Commun_11_1593_2020/assets
     ln --symbolic ${Commun_Phys_6_275_2023}/assets chapters/Commun_Phys_6_275_2023/assets
  '';
  nativeBuildInputs = [ just (latexPackages texlive) ];
  buildPhase = ''
    just full
  '';
  installPhase = ''
    mkdir -p $out
    cp 00_main.pdf $out/PhD_Dissertation_Westerhout.pdf
  '';
}
