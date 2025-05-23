class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "98ef8da08de68539a7ca92603c0737e56f6d92a32ee9c9d0c8c9af74af697ec0"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "13d56416675c3c4be525b12016208b16779724e4d1f1a598b50085127a741f31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f41841da54662885532b5106bba02210a7a790a27c6c03a004f4ab937b7e166d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4bee04ed57e3c0e9e05f2275eca4d28d679f8f88e058ff904ca2c47dd370c480"
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
