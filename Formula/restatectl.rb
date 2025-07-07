class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "2273d4c933b07aa0ad9b98f694251a22cb17f5375f13210a1d11c27e46f688aa"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "d1f1c756055b6668758def737f5de9aba26d5675aa91ce835549372588cc90d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "95fb6153892d374a858f4cf4d6ab9a4b3b6cb5535a8fc1e573e76c0244ba09a5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5a59905605868ecab9b3ab2f317e3fd14e77448fdabf721846cd7575146eb05b"
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
