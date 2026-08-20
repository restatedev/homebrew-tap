class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "40e90241d9c29a2066473d372e03eb6423c75b229821760747de2bcc30e45257"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ddaab31cab828905d0e4f561f71ad93e2bb4d489c9aedd2f3bf3ac4719250e24"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "566f103739b3362d07ec7198b498feae47f612e1d0d77dc961290b57baa70914"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1a67b5b4e0c5bad146aef36162c003db78c15087e0088559b269ba609f50a94c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "restate"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
