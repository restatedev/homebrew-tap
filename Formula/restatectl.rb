class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.12/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "65742aa862c02234d5cde56a2f61d7ec33b930d19985306bdf0246dfcdff52cd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.12/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "c38e1d03ca8488dde5e003c1109d4043a2705dd9009de5296780e6b5eb7b8d61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.12/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "4fc93c2edf5e84540ba5be9f5e42d8d37b672f27c017e3cc929f67a46708944d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.12/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "6fe8d46e028f1aee9afeeee9a89fc0d4798f37b152fc09fb19522f0906c38e0c"
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
