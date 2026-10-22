class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "8da2bf4a238359416002802e10b9f5173e8e9de08fecc962aee54eeb7b108d2e"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "53af6e8d5dc08559413a8adf0848d4b81c9cf88e23d115f0fe385a020c65a667"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.8.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d6d7eb99b398bd03003037ca20f6e5584fbc2fabc466602e943155a40285ae8d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.8.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "42b39473e88754ba9642f0595d8f87277504b2df01dd5e26a88b4354a46ac21b"
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
