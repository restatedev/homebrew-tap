class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "f7ae21d8b9b7ec180c673a77266b4bb42d477229ad98aae593adc0adfca34069"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "f9ae48ac46ab3f5fc1632e6b1175bc5a741a064be8d9265bcab9bb41d44831d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "6dd7f401e4ea1dae1b55e1480fe71a5124c8ed7f217539fa0082972dc14e2401"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.10/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "870fdc42782800b2025338ceb3d56b666800187f1b4e30560b8f1c116c83355e"
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
