class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "96106ce887475dc0d7c1aebe12ea4ca75f8ed26a00f36b4659c8372508b4f7fa"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "c823cbd38538974d023905ae69a6bfb294bb721f760c8cbf3de0276d8a65a35c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "13a3148182443fec11d9df9b0d8fc44d9e7126c3fe3cfa2d85c715e160a10cee"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.7/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d49944baaf58e61aaf1bee54de2d8ef5dd824cdff8b1957ff07a804a7dec0747"
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
