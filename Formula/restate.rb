class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b6366419506bf1efebc7cc7989e28f83057180908b708a5942fe853d23f7b3e3"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "36a93050fed35ae99fefe941d6bfceafe3edbe1285521f1363de929a18e633a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8ee2cbe1165ea18c6ad6f40e2691c2765ed2f46880c285770f102d5e766f3c37"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.2/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d3e24515a3ac20af66450cc09550d13e9870e14e29f8362ef25dfed63561100b"
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
