class Restatectl < Formula
  desc "Restate administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.2/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "86b7793b537113638031d765b5686334a47834f761b8f59ed045079282f02db2"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.2/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "e9988af43c262fe948ba90679d5b923a380f9c0841fedc3e52e143116ab00339"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.2.2/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "a7bed1a89cb3040adf4342fc3e8015f9644df50b02ffd2185a3fa679282745bc"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.2.2/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9fe0c7a35ae1b0953277215d8b7881b0d9212ff2b7c842417aee2d328c1e5d4b"
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
