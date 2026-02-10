class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "6c617263fae6fe7c9b515bb8ea9f420e816c15956e6ea67673db460e037632d9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "54f1eb961bdb33f57a3c89d4bdcc77f48d7e296a72ab6d12d2bab0ef773ccaa7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.6.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ba570213d684d34ec9cd9fdfd4c91fdeea568178aca77309425135560e2107ab"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.6.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f1a27c4c407830237e05dfc824f0c1bc67741ad53a6487ee6cc725b6495c72dd"
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
