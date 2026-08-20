class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.5/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "df6e472e84708037bdfdf4f4d2cda637ed5793cc3ce7e4a1f7c1070001e7910d"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.5/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "259e0ec05ae20c55a29fe3abb8c3a0cfeb16eefd1e2d084d358b411d9954c4db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.5/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "20f28a8227a94721939d2610cb198f5fbde36ca629613abedf5499955927cedc"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.5/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "12827c694559a99ea8ac772308a306ce186979602787400632dca7b82eecd261"
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
