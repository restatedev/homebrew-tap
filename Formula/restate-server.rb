class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "09325513097a790878a83d20ea3eca1c4973a8ddebe96510abcda848cd1c438f"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "d12f2c817f357019b3fa74847979ded2d7888e2ce654eae37e0e2f40e7d768cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b6cb7c107f9e15635fd9840c78028201382e4f11b5a5de1610dee2c343d821e5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.12/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6e0fe06b730a64c3690c8611800cb01ddd09812b8de603566c01b7b63f5f6868"
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
