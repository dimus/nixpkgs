{ lib, buildGoModule, fetchFromGitHub, stdenv, glibc }:

buildGoModule rec {
  pname = "gnparser";
  version = "1.6.6";
  date = "2012-05-17";

  src = fetchFromGitHub {
    owner = "gnames";
    repo = "gnparser";
    rev = "v${version}";
    sha256 = "sha256-6oGhdHA6I/ePqc+J6yofVlAM3uaNHfAI66E5k4iKQU8=";
  };

  vendorSha256 = "sha256-2xNbMm/L2OOLDJdKfUO1Lx/AM16RAeBlUPzBCrBEGRs=";

  buildInputs = [
    stdenv
    glibc.static
  ];

  subPackages = "gnparser";

  ldflags = [
    "-s"
    "-w"
    "-linkmode external"
    "-extldflags"
    "-static"
    "-X github.com/gnames/gnparser.Version=${version}"
    "-X github.com/gnames/gnparser.Build=${date}"
  ];

  meta = with lib; {
    description = "Parser for biodiversity scientific names";
    homepage = "https://github.com/gnames/gnparser";
    license = licenses.mit;
    maintainers = with maintainers; [ dimus ];
  };
}
