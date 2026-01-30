class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.0/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a127e40c3964332a5c4ca355f3341b9680224be482e154bb88ec9eaa454e4ec1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.0/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5286a52fb3db59ab8a90570e469729bb1d9ebf6163f4749ecc3e6a11ff8a1499"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.0/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8cf8e3e84be26407c4df3dce97bbe95a19427f3834b1506b4e4b96feb85cf696"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.0/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "cf5986322821bcb8c21cb56915ea9f006c261b48287404e010a88c37422aaf51"
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
