class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.3/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "0ab444f40dc0115bf9c446851da7b7a75ef425d926cabb26b5484440bc2a0338"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.3/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "96ff2b9c31f4086ac46fc0f498fc95d22a31b45efd4c0b1b7c36e0aaba7fc975"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.3/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "460fd16791eea7701bb3880b56c9f6ba17ae04ce6b1fe1af3f927f7bfd0c2fb0"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.3/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b5361d2435fcf076004494ea257701079465f6109626fd7fc670cfae85561fae"
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
