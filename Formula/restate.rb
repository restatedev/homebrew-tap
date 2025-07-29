class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e4994704b318366fc2bc16c1db7bb48847003735d91a2c954455869743ea6c46"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6e5e1e51ac2735110ec5e9843f851370bb5ac634ee9790b743023175725e38b4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5f6a009a2c53f157172c0a968598ca921b9157c177dc069739c1dc2b466bc8fc"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.3/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "359fd5d3454f7c64d262a59e2c1ca2145ab847e352b71e9d67726ef90eab58a3"
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
