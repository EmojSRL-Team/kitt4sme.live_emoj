#
# Custom Sealed Secrets package.
#
# Couldn't find any easy way to extend/override Nixpkgs 20.11's own
# kubeseal expression to make it build kubeseal 0.17.5
#
# - https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/kubeseal/default.nix
#
# So I've rolled out a bare build recipe whipped together by looking
# at what the kubeseal Makefile target does. To be replaced with the
# official Nixpkgs expression when it gets updated to build 0.17.5.
#
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
  version = "0.17.5";

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "sha256-7u7lsMeeZOUGn8eb8sjV9Td+XNEUPDvbSaITdp1JTf4=";
  };

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
