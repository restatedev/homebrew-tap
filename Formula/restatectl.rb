class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.8/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "82cf07a2fc946400be1ded88476e18022c290980ec309e17f1804845081cf119"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.8/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "9fa60a971ecf46936821a7fcf3ae87ce1097911f7a13ca4c2348409a43f403c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.8/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7fb6bfbacfbc603068d336f5952e591f1c64a79e78e098c271559c4eadc34d78"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.8/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ac676c50c4dcd6420c1e2d4adb4aa46ae54b6321d763e9c1ec6b2c339c086b0b"
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
