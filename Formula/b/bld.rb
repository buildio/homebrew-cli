class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.111.tar.gz"
  sha256 "44585d29a0bd8ebcb01833db21ffbdfb9ba989e0f0e7e1be6cf51ad82e41c3e7"
  license "AGPL-3.0-or-later"

  DARWIN_AMD64_BINARY_MIN_VERSION = "1.1.107".freeze

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  resource "darwin-amd64" do
    url "https://github.com/buildio/cli/releases/download/v1.1.111/bld-darwin-amd64.zip"
    sha256 "43865072202717d0b91fa74570d4f9113c56031c9daf7d23c861950b7dda56fc"
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
