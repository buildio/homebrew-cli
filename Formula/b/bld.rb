class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.107.tar.gz"
  sha256 "a14611922aa9367da285971207ee6341a86630a3db7790b76f6447a2353a7e48"
  license "AGPL-3.0-or-later"

  DARWIN_AMD64_BINARY_MIN_VERSION = "1.1.107".freeze

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  resource "darwin-amd64" do
    url "https://github.com/buildio/cli/releases/download/v1.1.107/bld-darwin-amd64.zip"
    sha256 "dce1a4db3a2e891f880c4aaa680b6054ebf9edc2fc648c70b4e5b70b617ac4c9"
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
