class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.113.tar.gz"
  sha256 "d2007cbd2148b62ce302fdff3c11dcbb0f484265307a2b8b7a9d87b616759262"
  license "AGPL-3.0-or-later"

  DARWIN_AMD64_BINARY_MIN_VERSION = "1.1.107".freeze

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  resource "darwin-amd64" do
    url "https://github.com/buildio/cli/releases/download/v1.1.113/bld-darwin-amd64.zip"
    sha256 "791a0e9a77db15f961eaa263e0d9151d11ed59c1b472892834bb9b0333021421"
  end

  if !OS.mac? || !Hardware::CPU.intel? || version < Version.new(DARWIN_AMD64_BINARY_MIN_VERSION)
    depends_on "crystal" => :build
    depends_on "libssh2" => :build
    depends_on "openssl@3" => :build
    depends_on "pcre" => :build
    depends_on "pkg-config" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.intel? && version >= Version.new(DARWIN_AMD64_BINARY_MIN_VERSION)
      resource("darwin-amd64").stage do
        bin.install "bld"
      end
      return
    end

    ENV["CRYSTAL_LIBRARY_PATH"] = [
      formula_opt_lib("pcre"),
      formula_opt_lib("openssl@3"),
      formula_opt_lib("libssh2"),
    ].join(":")
    mkdir bin
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/bld"
    bin.install "./bin/bld"
    ohai "----> Login to Build.io to get started."
    ohai "      bld login"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bld --version").chomp
  end
end
