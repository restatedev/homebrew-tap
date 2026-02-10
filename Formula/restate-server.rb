class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "5ae490af84d7ca2dd82207c5de1e04d5d63c3808b627ca8e44cba496da3e2d04"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "fbb45a4e9532ccbcb56ba487d70242545e175a307d0afe58677fca03919aad2e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a4cc3665b5f5b7a61c4da2bb77d6c20e2b59cf8975e565b3406befbc9b7460b1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fbc712dd01c2c33861f282409a1be57b3685185098b5000b018feab1379b69e3"
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
    bin.install "restate-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
