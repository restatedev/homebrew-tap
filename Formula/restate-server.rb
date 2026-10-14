class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "5bef1dd6fced0bf4309f1d4b8cd40042cc1c0b2dbea5009805e1a0504483769d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "e06cca0ed375e534bc64d68922a3f76874d72285edda4e0ae5a6e9875c2134f9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "518d037193ffae891833c91d5eb24531639774cf61a285482e981807215361e9"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.0/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d0ba8870eefd5e9d4b54d4a2a4b739b62cfe7bb86b1a444d497fa1989ac9bb36"
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
