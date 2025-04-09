class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "a58da27e95a7a4310a7dd3489ee8f3310903bef63aae7d6c6686005e2593da0f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "ae700db9fbc885e1de574fb49aae78023a5da6ca0526f9fca907d045a62728e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "037a53b9889f12959353be5abe2fb0be6e8007a77fec243d120521e3432231ee"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.0/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "78fe0be459cced5acfb7040aaa0d8486c64c0eaba1cf6d5619374a8d538239a1"
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
