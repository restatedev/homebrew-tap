class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "0db8e9a39e7fa8c484dc1ccab83236c0c80bd50920a38ff4652bdcb3db303d0e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "3359a1bb9a9177aae328f4c3f27a721b89eef34dbdaee3778a353ceeced506b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f4e8b38e3c8b36b2b98430fc71bdcd7b78fcc8b0c6c9e2c72d0985134c7491d9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.3/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d2a4aa97e344f6e0f1c5bd93e71b9097bdfd092f35e5ae8ecbc88f00e85b261b"
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
