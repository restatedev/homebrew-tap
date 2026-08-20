class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "d0f6056a1c986384c1b91fea097cdbf95770ca1faef05d55647f6d92010c3a08"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "5fde3a2785eeb16cef17b52d1eee0412841cd1007474cf39d7bd154cd3e7a945"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b0d9e9aaa1f249d8d2071599930e4c8a049041f576a870c7e5ab58ff0f10d748"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.5/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "08eae438fe87915f4cd5057fbfa5905b30d49d5f371b309f97077a122dcc4bb6"
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
      bin.install "restate-server"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate-server"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate-server"
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
