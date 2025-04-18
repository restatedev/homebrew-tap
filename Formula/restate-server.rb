class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "a54d6cf0afe4eaa23da0875468f210f2e65f9b61c08901211fa29de36b85026e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "b63f7504f8fb1dd23a558e5b6f08ad8ad90e14706cb3d1f6e602f5327a7764c4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "30286cf16d34c81f5b4c0cc9d3e4e6df937376211cfc88c3963a39b408e28917"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1a308857c944f528d2c184850857604c3c123d83724be185bc9740da41096867"
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
