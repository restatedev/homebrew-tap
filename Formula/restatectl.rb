class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.13/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "d948c960b46911ba5f0f946fc2bb6ffae198fdea4876fe54b88deb4bb9fbbcac"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.13/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "2a2cb193eca5cf7646326eecd63d4610a4802e6610f56e1a6939421fee1c393d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.13/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "237f33e17ee2a1885bc353d86a6675b4a2b1be0dce7bca5f1b35bde0335474db"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.13/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "864ebdcb88870be2b8c5a626a57755baeefda6dfb3475c28b8d3ee93925d876a"
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
      bin.install "restatectl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restatectl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restatectl"
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
