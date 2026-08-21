class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "f3543388b79b3e5d9e585c424e0abc9b18613c6ea8938a1f1796e7c7582533e9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "dd98e5ca566c6b6f14d11b3e8807d2f77a029fa845b021ebdc5ceb823ff03e1c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5ace0b486dd1adb019d5bdfd0bcbfcf2a980c506892e68604cf385119d063968"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.6/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "babb29fa5df88d349e84ab1e718388a29fe85982a4f2fe3b8aa45209bd6d0350"
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
