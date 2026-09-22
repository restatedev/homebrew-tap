class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "114c66899b8f5023da40760cadf71135a3caa3c13ed92f349647ac64336e79a9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bd891da4d6b2f542153e9afadc33d8efe99f11dd016075e66d5ceb9d47e15db5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a5921046ce1681bfa650e4f948c5dc5b589fcb2f8bbeb88d91e6af6caf486d2a"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c41b37fb1e18cc7273e58df96c7d4c76c973747249800b177276ac609dfb2099"
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
