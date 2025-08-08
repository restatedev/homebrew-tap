class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.4/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "9afa1f6359aa44c1f2d439a05a007f4220ebe5d432eceaa75a9595d43ab061fc"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.4/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "cd09421ec30cc850258c5a4a77184584de0fb88090b394f9f97515dc2ceb758f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.4/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8a6e687d4ac976088cd23ec1c9636e14af45107025ca1137e919db7e2d4fd74a"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.4/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1835fed2e5d572016e535145a6af1312d4ad52a36b04cfc9e68e50ef933f608c"
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
