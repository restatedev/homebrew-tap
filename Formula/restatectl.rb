class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.9/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "2aa4ec3ea95545de5e0d2a86b436f643d6b2d75e23a31f290ea92d6c879e394c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.9/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "d4b7ca8f043f48f42f3032b7b661bf2ad1d60e80628b89922664d40c48b33278"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.9/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "937352a6683d20adff2920dfab68f18d4b866e8923cd3d9f4664db39201cae52"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.9/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e4c2c9548b8f8ab2a9f2e20f1779745ba34a48e65b610dfab303f838b9761d3d"
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
      bin.install "restatectl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restatectl"
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
