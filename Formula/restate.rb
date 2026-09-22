class Restate < Formula
  desc "Restate CLI"
  homepage "https://github.com/restatedev/restate"
  version "1.7.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5356d88a40d1807fc63c06d1c0ee7e593edfafd2a1099e5b23b2f9140c63cccb"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-cli-x86_64-apple-darwin.tar.xz"
      sha256 "cec0c88cde4e6a94542bbf49efeab07af988377e038d5974cf9d969b6c77fc63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "0355aefccd7bbf09b466588ad9e960c7348eb4a10951165eb73674a874863086"
    end
    if Hardware::CPU.intel?
      url "https://restate.gateway.scarf.sh/v1.7.11/restate-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "26f0b12f00c0f1c233689497851b448a6200b435b9fe614bc19fdb82ea3cd83f"
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
      bin.install "restate"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "restate"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "restate"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "restate"
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
