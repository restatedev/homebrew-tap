class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "84fc243c831e39d888a3ac1e8b7a2e8a3dbdf3bd6e1b640c78c6cdd24920ceb1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "4a0a88eb49c51e049243dbf7a40054c6ca4b7f84d6b1469cd319bf98e70daf9c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d7e88cb0c390b2cc1c56ee788f1dbb91a3bfb4400db6ae4ea2f491a36ea43bb2"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a2b7b6accb4a166c136efa5696dd7c8e541798a78cc0120fdb98eeca7d457d5b"
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
