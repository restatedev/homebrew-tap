class RestateServer < Formula
  desc "Restate Server"
  homepage "https://github.com/restatedev/restate"
  version "1.7.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-server-aarch64-apple-darwin.tar.xz"
      sha256 "954cc9f3f75c0a2c024b32b2aa494954da0bce6968dba7ce239cb27320aa6028"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-server-x86_64-apple-darwin.tar.xz"
      sha256 "62e1a03c610e9a195ba8420f9df8419b1d072f9cffe142089eb41ed2b49b721a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-server-aarch64-unknown-linux-musl.tar.xz"
      sha256 "88f2e46d754642bb9e100120a7fa8e9a9cb6ab6f5d640a430532ca68709ca312"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-server-x86_64-unknown-linux-musl.tar.xz"
      sha256 "73cb2599da355a5b5246586f8a7488919b5ceaae6ebcc077eafec88ee205cba4"
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
