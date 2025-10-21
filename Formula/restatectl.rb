class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.3/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "26d3350f97e58bba3427b02a051ed39ffbefd9c7ca1b09467a11e2c6dfa2b86c"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.3/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "8425dd03a5044cb15aa23726878ffbb06c9fc9ad0ac4b31b97610f78cde4b6be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.5.3/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f51e7ec9a506ce78a28e867224ec27a294f75b6d3221781a2954ee0b5c578ad2"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.5.3/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c1c4a0fd98882f8e3864adbee2a5aa79672d896a10f7e84d61ba9d0dabff90b3"
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
