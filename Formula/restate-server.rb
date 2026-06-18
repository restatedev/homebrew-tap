class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.0/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "a4d2a5fd70108e0cd77eec5ce81dad553346955557f827a89cfcb117396224be"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.0/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "79f01587e161b42e2b395042f8fea4b7124d6a5a1fcf7b76e480d052e78744e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.0/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "3135f1252e54d743d8cea932f38e31463248af5f1ed63b8d7bbd73fb30ed65ff"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.0/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "323eff8d4f98658a009dba4c94343e37145c5f043f14ee2ff957be06c6535749"
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
