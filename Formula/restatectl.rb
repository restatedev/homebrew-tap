class Restatectl < Formula
  desc "Restate cluster administration tools"
  homepage "https://github.com/restatedev/restate"
  version "1.7.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.10/restatectl-aarch64-apple-darwin.tar.xz"
      sha256 "fb970ca6a054f606ae04374cf139e53d274ca322c1718386827aea2942609c56"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.10/restatectl-x86_64-apple-darwin.tar.xz"
      sha256 "0168cdb883c0ce4725e73a1183a6f4942c9d5259ed38cf63e0bdd10ced84ceb4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.10/restatectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "5118cd2fde404b0925e0720b014161a7ec28b1f957da8b5ef75badca88aeb9d7"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.10/restatectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "79fc626151196ccf9c37af4880e530dc4841f98b70e9c42940214ca55128232f"
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
