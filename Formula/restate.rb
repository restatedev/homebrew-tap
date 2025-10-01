class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9542dafba121b5680b9fc32790e35797b8d2dec50797344c87f557c0114185f6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6a75c26978e48a7116e39256c1d248201a458cc47006470c378172970d54560e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "396105a4239b1d5728fd2d8146b7acebd58c3ffbd58689b214a6b4a6ed8a4518"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.1/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "23a79358b3668515c8a79ce8b9c8922ef833cb72a6aa78af2a7b614d3611fafe"
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
