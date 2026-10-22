class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.14/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "5e14ada321f0e33165d8010c75f4f1ac013fdeb9175c2b15da5890788f3315f5"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.14/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "8b51bf168062e696cf01f039bc7802c15365bc609c9913f5de08cb7f19b518a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.14/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "caea7954042fafe8a0d8168f5de9c4586188d73ee8b4601504209e272fd55bbc"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.14/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "40a906fae9f0fbfde3d396e708c695b6b895ce755b2510367b5c6a2ab848ac50"
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
