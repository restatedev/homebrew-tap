class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "17cb23a4916a7d9a7bd19896f72813f5e139257b627c75c4ab0345b18059652a"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "3f4fd91caca7c9c365a7ff6da51cd9afb1d6771d653eef7f2fb884511d709903"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8322457d39c96466f3f685eb8448f6de149bf29df165f98efae6062b9ed787c0"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.4/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "393c63c82f4bfb3b045cdf9abe3a6cb43cfebe9e3c39f497c897660584e80577"
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
