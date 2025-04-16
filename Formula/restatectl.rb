class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.3/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "55425ba0c0ef157c331beeea325605ed0ccee23db873cc273411fca003b54cf1"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.3/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "f440486e224c288c39f86ee95a869bbdc4c046814884be9b5d7f874c182d2246"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.3/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3582bc97f298ee887d0542b77cce6dc06a23b9af2f8e0bae3033b56c5ab2d6cf"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.3/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fe4a01fbec28a2a2c4035193149ef122922490c82c49ccdfff34a2ad5160cf53"
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
