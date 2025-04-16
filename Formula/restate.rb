class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "353c6e863371ce8045707593a41c29fe82179c1d7788bb69cc7d01e167a00220"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "00e9a82880400a8b35561af1b516aa08888ba7ce8797b603b791febf9b707103"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "db90f65740cda8dc4b5d84057ee2d12e754cee6353534a7303542b43b6b38a64"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0359b0e58fe65dad1fb9d12595df0706fee03b7bd9b47dc0dd513cf850a769f0"
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
