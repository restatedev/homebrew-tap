class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.13/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "503c9a74eaad9b3579a373a5cd558b6910b179d17d87c2a75307cd975d1a299d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.13/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "8bebb7787f003530e4959631111505b5003c87470e8ce3c070b6d02aff73ca89"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.13/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c0218d5ae5052cc2c6f842bbcfa57fd10240cfe30795c381850c452fbcef2b61"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.13/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5429b216b68f3fa52b7f0e6627a2c2a86fc0c75d19b1e152cd2e7dcd8bab4c82"
    end
  end
  license "BUSL-1.1"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "restate-server"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate-server"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
