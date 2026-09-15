class Bld < Formula
  desc "Add *bld* to your shell to interact with your Build.io applications"
  homepage "https://build.io"
  url "https://github.com/buildio/cli/archive/refs/tags/v1.1.122.tar.gz"
  sha256 "badb4df99b513466655bd15155a9a9287c64019e1a5db972ef2d9046c91ab0db"
  license "AGPL-3.0-or-later"

  DARWIN_AMD64_BINARY_MIN_VERSION = "1.1.107".freeze

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  resource "darwin-amd64" do
    url "https://github.com/buildio/cli/releases/download/v1.1.122/bld-darwin-amd64.zip"
    sha256 "a86b0bc09f3eac7a685a045a96440ed6e246c68d92578c064d754da80b41220d"
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
