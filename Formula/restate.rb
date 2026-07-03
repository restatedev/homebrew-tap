class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8703d49fa234ba070f73b601bf533f98b6f3c6f005292eda8341343e1b697f6c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d140165ce7d879e0816cf715267fc839f4af67a2d0da117dcd1591b8a2a6ad6c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "2bdbae746e3453549d99265fb610c96b3a2bdd2c09c6d46323464e70cd6fd5c6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6409ec1a506f9343625d63fcab93c440676e7e27f6f1aad0a82c73b52e462f24"
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
