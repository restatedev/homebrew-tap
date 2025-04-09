class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.0/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "a435fd6fe75f0505715f5f844c6df0ec8b20fc2487e3eee08f86978afb3f6afd"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.0/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "1f0ba5abc90ee0a16c004f0f235b5176ce5b6a8b80e1f5adb89656cacbf3faba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.0/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "07e406d5d83e8707d578953a2a0d03a34756fe530a5d5d323ebdef0cb4e03366"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.0/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "f31fc937bc89cc3a6458ebeb932b58ca6bd67b26288b748bc99620f0c676efb4"
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
