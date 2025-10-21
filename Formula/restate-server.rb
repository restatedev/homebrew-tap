class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "71f9e13e2bfec0907efbca0b5e9c6208f5303fed5fe63494ee45e8eb822bf504"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "3bdf11d2dcde05de09eed34f568df4e2990744f26b23733e3413f48e11c81a8b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3c45cbd6686ee2f9e09776ef1ba773894d6157ea4897a30e96857ff6495280da"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.3/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "235737482febc7f337a973d7921a7a5f3d101386b6a372b2b30e673c786281ce"
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
    bin.install "restate-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
