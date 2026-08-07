class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "f8b08352c4e88a6d3eb02139393100f29364038ebe5b5f7e6ab52f1203e0b144"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "0ba9d1b49e72451842ad5ad0fe96bda33ff47be09749a01dd2ea81cc7493b3ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ff3ed6682ab3ee2f22431f5d491c18b24fc8f0474d7e492234cfe32cbd48017d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.3/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7446cb12197a15e2c230cc9df050e40e4cc89499edaead1ff614b55cb9b4a140"
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
