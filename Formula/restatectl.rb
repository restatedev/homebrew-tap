class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "466580bc6cc1b0902f59bfcb9c008a5fdf0cf9e1525f54be6f1b94ab3ea09fb7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "b0fa3bfe47077b37c65922a432dfd3f4b8b0df410248a0e7919179f1c20a88a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "574b8595e0223cc2f14f6e684e287fcf6e8bd5e567f343ecbbc694798a87c064"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f4cc1e8be3778f8e9bc865263404e7ca5f4de82a4dd26d302ec1269fa2222f5c"
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
    bin.install "restatectl" if OS.mac? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.mac? && Hardware::CPU.intel?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.arm?
    bin.install "restatectl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
