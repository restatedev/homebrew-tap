class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "cc0b226350fa10338c624bd92899bc0fa1151a1dbe824c9d6a30c0bf77bfa03e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d19a04b24965eafdb701805ab00a985727908992b6104b39ffab7d8bce366cfc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "e47223ecf20c79c8def0523bc7810cc71cd72c5cb70d58b2ba0fead15fc5adc2"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.0/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "32a7e3a067df0fd5a08b88e738c0aefdfe70b57aa8e61c087b4a2b33b472f88b"
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
    bin.install "restate" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
