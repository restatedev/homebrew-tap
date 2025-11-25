class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "81d4a5f92d3c8bc9e40dcf0e07799c8c96a3b25e7437b42f6905df13e95b5754"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "797699061782cec43db25d0925b1f5d70387453947d72c235c3297abbe67605c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0428a09d2ada5d594ed9b1a28f1e00487897b80d60389791dbb56d3a1ec5e9a1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "712f5314d469cbe2b1ec76ca35aaa1cf9fbc4df5382f1dec4261d03b2424420b"
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
