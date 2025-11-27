class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.5.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.5/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "22f1852cfc31402873c944bb3bc6f4c24c11d8f50b52bcf51403ea7ae49b9ac6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.5/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "966ac7c13a429cca3b649faa18dfaaff49af25bc991964e90933a6d6d0a0dfb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.5/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0fc31a439908ab7d5161f53385658f92ea96e3ca3fbbb76597dc39d260e22db4"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.5/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b187d9be269ee8420b8f7bc80393fe46c5cf0ccb50ecaada34f25885848541ce"
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
