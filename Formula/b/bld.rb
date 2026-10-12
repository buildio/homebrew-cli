class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.143.tar.gz"
  sha256 "17dfb3570896e8aa1db7fbb06cd475bb7f8d377882c84a2cba2f1f09da32ba4b"
  license "AGPL-3.0-or-later"

  DARWIN_AMD64_BINARY_MIN_VERSION = "1.1.107".freeze

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  resource "darwin-amd64" do
    url "https://github.com/buildio/cli/releases/download/v1.1.143/bld-darwin-amd64.zip"
    sha256 "29eb8867fee84843ca118e27366a3a36c7b2c2eff5318f1690a36a8133e5dd7e"
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
