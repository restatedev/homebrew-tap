class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.1/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "ad38f735e79b006c6e111eba7c89a3b65fcf6f9658992477ce79e12a0efdb2da"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.1/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "9156bd8ff718ce41b250e3dce0b03bdcdf245932f12c702aa2b7f0f400803169"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.3.1/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f09287840e44fd98eba65541c3069639c2a107c7395f3833ac726fbdbcb78690"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.3.1/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "262891aeb968dccb70dbc3cbf99a0cfd9bf24cbae40b5e8bcc0dc890689cbea2"
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
