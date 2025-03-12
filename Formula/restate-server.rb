class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "889b3092004adf349cb1356b8eadfec30e1f733731ceb75a3c75fa5cf8f020e6"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "403c5daf5f67b9010b0850ff72e85d2d77273b944e08b6fc2485b06808a0568d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "47f50ff6b1eb9172f1a50e5824cc11c4c2de20ab914f07bdb7ca3a2f6ae5111d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.2/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5a6897b63f717aafca032f3564791130a6eaf1e0a241c232aa7ae8251654972a"
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
    bin.install "restate-server" if OS.mac? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.mac? && Hardware::CPU.intel?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.arm?
    bin.install "restate-server" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
