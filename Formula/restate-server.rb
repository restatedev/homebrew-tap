class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "228e133bc8af2d22547c5d89744b36baf460b5b6f3bbc38bef29d165334d6a07"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "09efbde9c9b763d6abae060fe592b720832c84cf1cda940436372a8490437257"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "62793eb55bde23cef2728c8483d5ddd2af398478b6a8a1f96a528695f8b89b09"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.8/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e527f20b8788564a9bb90effedb7cb82b0e36d72f025011e89de465d675d8e33"
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
