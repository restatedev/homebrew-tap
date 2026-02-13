class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8c1b1dfb8294ad44916819283065bc8a98b9eab0ca8564724629477d9c6e7eec"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6ccff343e345aadb0d40f8fd0f2c09e848bc69a44869a3b4ecb5a3e851748b5c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "16ad6a2964c398553ae8da910f76d36b3be8ad9a8ac301963918f06f8ad1869d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.2/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d671bf2434b410ddf03cf73f73914ccecedd60bfc3d66e841a3d7f9258139e54"
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
    bin.install "restate" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
