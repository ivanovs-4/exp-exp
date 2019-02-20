{ mkDerivation, base, expresso, stdenv, text }:
mkDerivation {
  pname = "exp-exp";
  version = "0.1.0.0";
  src = ../../.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base expresso text ];
  executableHaskellDepends = [ base ];
  doHaddock = false;
  license = stdenv.lib.licenses.bsd3;
}
