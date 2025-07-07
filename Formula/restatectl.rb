class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "ab317358917a65269d8efe266d46aa56ba7dfaf55fc17dcb696dbb34f61b0290"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "49143c6b83678289344d360d6a18d77a32ef3187ddbbcd87448c05e7d87888e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9d11c90b9cbc1b7d8e3363060f5e4bde17dd6277400558d72196ce088d1291fd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f2aa4e85e63b2655f8c162f5b8c3edfae60ff4dd1e5213618a0e51a0da09b390"
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
