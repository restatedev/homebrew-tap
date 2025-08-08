class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.4.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.4/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "13a7c8cad166d3d45e9aadf756e48ef5800fc1fabf9362dc909ef089a10ce43d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.4/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "60bcc005c4579fc283608917a24adc8dd96e273ecbd2d71fb49f892bcf0515eb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.4.4/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "71f34366b11e77d3282b01980d49b71f5da4e9b7e4ca5523be1ae09f05879830"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.4.4/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1727d695c4a2632a9b75d3d187a6dbf3e1bb879b3e9b342fe14b62366aeeb894"
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
